const std = @import("std");

pub fn main() anyerror!void {
    const allocator = std.heap.page_allocator;

    const buf = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 14000);
    defer allocator.free(buf);

    var vec1: [1024]u32 = undefined;
    var vec2: [1024]u32 = undefined;
    var i: usize = 0;

    // read file line by line
    var lines = std.mem.splitSequence(u8, buf, "\n");
    while (lines.next()) |line| {
        if (line.len > 0) {
            // split line into two sections
            var cols = std.mem.splitSequence(u8, line, "   ");
            const f = try std.fmt.parseInt(u32, cols.first(), 10);
            const s = try std.fmt.parseInt(u32, cols.next().?, 10);
            vec1[i] = f;
            vec2[i] = s;
        }
        i += 1;
    }

    // now arrays have been loaded with numbers

    // next step is sorting each vec
    std.mem.sort(u32, &vec1, {}, std.sort.asc(u32));
    std.mem.sort(u32, &vec2, {}, std.sort.asc(u32));

    const entry_count = i - 1;
    // now iterate over each entry and calculate the distance
    var total_distance: u64 = 0;
    while (i > 0) {
        i -= 1;

        const a = vec1[i];
        const b = vec2[i];
        var distance: u32 = 0;
        if (a > b) {
            distance = a - b;
        } else {
            distance = b - a;
        }

        total_distance += distance;
    }

    std.debug.print("Total Distance: {d}\n", .{ total_distance });
    std.debug.print("Entry Count: {d}\n", .{ entry_count });
}
