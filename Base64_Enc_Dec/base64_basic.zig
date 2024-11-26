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

pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    if (input.len == 0) return "";

    const n_out = try calcEncodeLength(input);
    var out = try allocator.alloc(u8, n_out);
    var buf = [3]u8{ 0, 0, 0 };
    var count: u8 = 0;
    var iout: u64 = 0;

    for (input, 0..) |_, i| {
        buf[count] = input[i];
        count += 1;

        if (count == 3) {
            out[iout] = self.charAt(buf[0] >> 2);
            out[iout + 1] = self.charAt(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
            out[iout + 2] = self.charAt(((buf[1] & 0x0f) << 2) + (buf[2] >> 6));
            out[iout + 3] = self.charAt(buf[2] & 0x3f);

            iout += 4;
            count = 0;
        }
    }

    if (count == 1) {
        out[iout] = self.charAt(buf[0] >> 2);
        out[iout + 1] = self.charAt((buf[0] & 0x03) << 4);
        out[iout + 2] = '=';
        out[iout + 3] = '=';
    }

    if (count == 2) {
        out[iout] = self.charAt(buf[0] >> 2);
        out[iout + 1] = self.charAt(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
        out[iout + 2] = self.charAt((buf[1] & 0x0f) << 2);
        out[iout + 3] = '=';
        iout += 4;
    }
    return out;
}
