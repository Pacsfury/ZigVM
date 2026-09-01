const std = @import("std");

const operations = enum(u8) { nop = 0x00, push = 0x01, pop = 0x02, add = 0x03, sub = 0x04, mul = 0x05, div = 0x06, dup = 0x07, res = 0x08, jmp = 0x09 };

const code = [_]u8{ @intFromEnum(operations.push), 0x06, @intFromEnum(operations.dup), @intFromEnum(operations.div), @intFromEnum(operations.res), @intFromEnum(operations.push), 0x00 };

pub fn run(program: []const u8, stack: *std.ArrayList(i32), allocator: std.mem.Allocator) !i32 {
    var pc: usize = 0;
    while (pc < program.len) {
        const op: operations = @enumFromInt(program[pc]);
        pc += 1;
        switch (op) {
            .nop => {},
            .push => {
                const val = program[pc];
                pc += 1;
                try stack.append(allocator, @as(i32, val));
            },
            .pop => {
                _ = stack.pop();
            },
            .add => {
                const b = stack.pop() orelse 0;
                const a = stack.pop() orelse 0;
                try stack.append(allocator, a + b);
            },
            .sub => {
                const b = stack.pop() orelse 0;
                const a = stack.pop() orelse 0;
                try stack.append(allocator, a - b);
            },
            .mul => {
                const b = stack.pop() orelse 0;
                const a = stack.pop() orelse 0;
                try stack.append(allocator, a * b);
            },
            .div => {
                var b = stack.pop() orelse 1;
                const a = stack.pop() orelse 0;
                if (b == 0) {
                    b = 1;
                }
                try stack.append(allocator, @divTrunc(a, b));
            },
            .dup => {
                try stack.append(allocator, @as(i32, stack.items[stack.items.len - 1]));
            },
            .res => {
                std.debug.print("{}\n", .{if (stack.items.len > 0) stack.items[stack.items.len - 1] else 0});
            },
            .jmp => {
                const target = program[pc];
                pc = @as(usize, target);
            },
        }
    }
    return if (stack.items.len > 0) stack.items[stack.items.len - 1] else 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var stack = std.ArrayList(i32).empty;
    defer stack.deinit(allocator);

    const result = try run(&code, &stack, allocator);
    std.debug.print("\nProgram exited with code {}\n", .{result});
}
