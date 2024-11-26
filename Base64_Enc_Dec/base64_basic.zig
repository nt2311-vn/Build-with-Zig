const std = @import("std");

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers = "0123456789+/";

        return Base64{ ._table = upper ++ lower ++ numbers };
    }

    pub fn charAt(self: Base64, index: u8) u8 {
        return self._table[index];
    }
};

fn calcEncodeLength(input: []const u8) !usize {
    if (input.len < 3) {
        const n_output: usize = 4;
        return n_output;
    }

    const n_output: usize = try std.math.divCeil(usize, input.len, 3);

    return n_output * 4;
}

const base64 = Base64.init();

pub fn main() !void {
    std.debug.print("Character at index 28: {c}\n", .{base64.charAt(28)});
}
