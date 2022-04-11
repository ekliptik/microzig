
const InterruptVector = extern union {
    C: fn () callconv(.C) void,
    Naked: fn () callconv(.Naked) void,
    // Interrupt is not supported on arm
};

const unhandled = InterruptVector{
    .C = struct {
        fn tmp() callconv(.C) noreturn {
            @panic("unhandled interrupt");
        }
    }.tmp,
};

pub const VectorTable = extern struct {
    ResetHandler: InterruptVector = unhandled,
};
