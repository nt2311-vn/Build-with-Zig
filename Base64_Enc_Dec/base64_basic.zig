const std = @import("std");

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers = "0123456789+/";

        return Base64{ ._table = upper ++ lower ++ numbers };
    }

    pub fn char_at(self: Base64, index: u8) u8 {
        return self._table[index];
    }
};

const base64 = Base64.init();

pub fn main() !void {
    std.debug.print("Character at index 28: {c}\n", .{base64.char_at(28)});
}
