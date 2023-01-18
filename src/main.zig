const std = @import("std");
const capy = @import("capy");
pub usingnamespace capy.cross_platform;

var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};

pub const ListModel = struct {
    size: capy.DataWrapper(usize) = capy.DataWrapper(usize).of(10),
    arena: std.heap.ArenaAllocator = std.heap.ArenaAllocator.init(general_purpose_allocator.allocator()),

    pub fn getComponent(self: *ListModel, index: usize) capy.Button_Impl {
        const text = std.fmt.allocPrintZ(self.arena.allocator(), "Label #{d}", .{index + 1}) catch unreachable;
        const label = capy.Button(.{ .label = text });
        return label;
    }
};

pub fn main() !void {
    try capy.backend.init();

    var list_model = ListModel{};

    std.debug.print("{any}", .{list_model});

    var window = try capy.Window.init();
    try window.set(
        capy.Stack(.{
            capy.Rect(.{ .color = capy.Color.comptimeFromString("#f6f6ef") }),
            capy.Column(.{}, .{
                capy.Stack(.{
                    capy.Rect(.{ .color = capy.Color.comptimeFromString("#ff6600") }),
                    capy.Label(.{ .text = "Hacker News", .alignment = .Left }),
                }),
                capy.ColumnList(.{}, &list_model),
            }),
        }),
    );

    window.setTitle("Simple Email");
    window.show();

    capy.runEventLoop();
}
