const std = @import("std");

pub fn main() anyerror!void {
    const allocator = std.heap.page_allocator;

    const buf = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 14000);
    defer allocator.free(buf);

    var vec1: [1024]u32 = undefined;
    var vec2: [1024]u32 = undefined;
    var entry_count: usize = 0;

    // read file line by line
    var lines = std.mem.splitSequence(u8, buf, "\n");
    while (lines.next()) |line| {
        if (line.len > 0) {
            // split line into two sections
            var cols = std.mem.splitSequence(u8, line, "   ");
            const f = try std.fmt.parseInt(u32, cols.first(), 10);
            const s = try std.fmt.parseInt(u32, cols.next().?, 10);
            vec1[entry_count] = f;
            vec2[entry_count] = s;
            entry_count += 1;
        }
    }

    // now arrays have been loaded with numbers
    
    // fill the index buffer with the values of duplicates from the second column
    // I'm sure there's a better way of maintaining an index of up to 100,000 entries, but I can't think of it right now.
    var index_buf: [100_000]u8 = undefined;
    @memset(&index_buf, 0);
    var i: usize = 0;
    while (i < entry_count) {
        const index = vec2[i];
        std.debug.print("index: {d}\n", .{index});
        index_buf[index-1] += 1;
        i += 1;
    }

    // compute similarity score
    var similarity_score: u64 = 0;
    i = 0;
    while (i < entry_count) {
        const entry = vec1[i];
        const multiplier = index_buf[entry-1];
        similarity_score += entry * multiplier;
        i += 1;
    }

    std.debug.print("Similarity Score: {d}\n", .{ similarity_score });
    std.debug.print("Entry Count: {d}\n", .{ entry_count });
}
