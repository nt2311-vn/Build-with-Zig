const std = @import("std");
const stdout = std.io.getStdOut().writer();

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers = "0123456789+/";

        return Base64{ ._table = upper ++ lower ++ numbers };
    }

    fn charAt(self: Base64, index: u8) u8 {
        return self._table[index];
    }

    fn charIndex(self: Base64, char: u8) u8 {
        if (char == '=') return 64;

        var index: u8 = 0;
        for (0..63) |_| {
            if (self.charAt(index) == char) {
                break;
            }

            index += 1;
        }

        return index;
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

fn calcDecodeLength(input: []const u8) !usize {
    if (input.len < 4) {
        const n_output: usize = 3;
        return n_output;
    }

    const n_output: usize = try std.math.divFloor(usize, input.len, 4);
    return n_output * 3;
}

const base64 = Base64.init();

pub fn main() !void {
    std.debug.print("Character at index 28: {c}\n", .{base64.charAt(28)});
}
