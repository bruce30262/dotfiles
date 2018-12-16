import voltron
from voltron.plugin import CommandPlugin, VoltronCommand

import pygments
import pygments.formatters
from pygments.token import *

import traceback
import six
import struct

MAX_LINE = 100
class TelescopeCommand(VoltronCommand):
    def invoke(self, *args):
        def usage():
            print("Usage: tel <expr of a address> <line number (default:10)>")
            print("Example:")
            print("tel $rsp+0x10 30")

        if len(args) == 1 and args[0] == "help":
            usage()
            return

        expr, line_num = None, 10
        if len(args) == 1:
            expr = args[0]
        elif len(args) == 2:
            expr, line_num = args[0], int(args[1])
        else:
            usage()
            return

        res = None
        try:
            target = voltron.debugger.target()
            addr = None
    
            # get target address by evaluating expression
            import lldb
            ret_val = lldb.SBCommandReturnObject()
            cmd = "expr {}".format(expr)
            lldb.debugger.GetCommandInterpreter().HandleCommand(cmd, ret_val)
            if ret_val.Succeeded():
                resp = ret_val.GetOutput()
                addr = int(resp.split("=")[1].strip())
            else:
                print("Invalid target: {}".format(expr))
                print("Error message:\n{}".format(ret_val.GetError()))
                return

            # read memory
            if line_num > MAX_LINE: line_num = MAX_LINE
            read_len = target['addr_size'] * line_num
            memory = voltron.debugger.memory(address=addr, length=read_len, target_id=target['id'])
            # deref pointers
            deref = None
            fmt = ('<' if target['byte_order'] == 'little' else '>') + {2: 'H', 4: 'L', 8: 'Q'}[target['addr_size']]
            deref = []
            for chunk in zip(*[six.iterbytes(memory)] * target['addr_size']):
                chunk = ''.join([six.unichr(x) for x in chunk]).encode('latin1')
                p = list(struct.unpack(fmt, chunk))[0]
                try:
                    ptrs = voltron.debugger.dereference(pointer=p)
                    if ptrs[-1][0] == 'pointer': # you are not done yet !
                        ptr = ptrs[-1][1]
                        val = voltron.debugger.memory(address=ptr,length=target['addr_size'], target_id=target['id'])
                        val = list(struct.unpack(fmt, val))[0]
                        ptrs.append(('val', val))
                    deref.append(ptrs)
                except:
                    deref.append([('val', p)])
            # format
            output = ""
            cur_addr = addr
            f = pygments.formatters.get_formatter_by_name("terminal256", style="volarized")
            for i, datas in enumerate(deref):
                addr_str = "{:02d}:{:04x}| 0x{:X}: ".format(i, i * target['addr_size'], cur_addr)
                output += pygments.format(self.format_str("address", addr_str), f)
                for d in datas:
                    t, item = d
                    output += pygments.format(self.format_str(t, item), f)
                output += "\n"
                cur_addr += target['addr_size']
            # print final output
            print(output)
        except Exception:
            print(traceback.format_exc())

    def format_str(self, t, item):
        if t == "pointer":
	    yield (Number.Hex, "0x{:X} => ".format(item))
        elif t == "string":
            for r in ['\n', '\r', '\v']:
                item = item.replace(r, '\\{:x}'.format(ord(r)))
            yield (String.Double, '"' + item + '"')
        elif t == "unicode":
            for r in ['\n', '\r', '\v']:
                item = item.replace(r, '\\{:x}'.format(ord(r)))
            yield (String.Double, '"' + item + '"')
        elif t == "symbol":
	    yield (Name.Function, '`' + item + '`')
        elif t == "circular":
	    yield (Text, '(circular)')
        elif t == "val":
	    yield (Token, "{:#x}".format(item))
        elif t == "address":
	    yield (Name.Label, item)

class TelescopeCommandPlugin(CommandPlugin):
    name = 'tel'
    command_class = TelescopeCommand

