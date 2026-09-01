# ZigVM
Developing another simple stack-based virtual machine, this time written in Zig to learn more about VMs and the language.

---

## Operations

0 - NOP - _No operation_

1 - PUSH - _Adds next number at stack_

2 - POP - _Deletes top stack number_

3 - ADD - _Sums two top numbers, pops them and push the result_

4 - SUB - _Subs two top numbers, pops them and push the result_

5 - MUL - _Mulitplies two top numbers, pops them and push the result_

6 - DIV - _Divides two top numbers, pops them and push the result_

7 - DUP - _Duplicates top stack item_

8 - RES - _Prints top stack item_

9 - JMP - _Goes to the next program number_

## Examples

### Divide 6 by itself

```
@intFromEnum(operations.push), 0x06, @intFromEnum(operations.dup), @intFromEnum(operations.div), @intFromEnum(operations.res), @intFromEnum(operations.push), 0x00
```

Or

```
0x01, 0x06, 0x07, 0x06, 0x08, 0x01, 0x00
```

So basically, what the program does is: 


| **PUSH** | 6   | **DUPLICATE 6** | **DIVIDE** | **PRINT TOP** | **PUSH** | 0    |
|----------|-----|-----------------|------------|---------------|----------|------|
| 0x01     | 0x06| 0x07            | 0x06       | 0x08          | 0x01     | 0x00 |

We push zero at the end (we could do other operations, tho) because the VM gets the top of the stack and uses it as the program result. And code 0 means all right.
