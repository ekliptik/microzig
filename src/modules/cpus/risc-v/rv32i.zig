const std = @import("std");
const microzig = @import("microzig");

pub const startup_logic = struct {
    extern fn microzig_main() noreturn;

    extern var microzig_data_start: anyopaque;
    extern var microzig_data_end: anyopaque;
    extern var microzig_bss_start: anyopaque;
    extern var microzig_bss_end: anyopaque;
    extern const microzig_data_load_start: anyopaque;

    pub fn _start() callconv(.C) noreturn {

        microzig_main();
    }
};

pub const vector_table = blk: {
    std.debug.assert(std.mem.eql(u8, "ResetHandler", std.meta.fields(microzig.chip.VectorTable)[0].name));
    var asm_str: []const u8 = "j microzig_start\n";

    const T = struct {
        fn _start() callconv(.Naked) void {
            asm volatile (asm_str);
        }
    };

    break :blk T._start;
};

pub fn cli() void {
    asm volatile ("nop");
}