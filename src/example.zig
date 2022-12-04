//! The simple example on tkrzw's website

const std = @import("std");
const tkrzw = @import("tkrzw");

pub fn print_value(dbm: tkrzw.DBM, key: []const u8) void {
  if (dbm.get(key)) |value| {
    std.debug.print("{s}\n", .{value});
    tkrzw.free(value);
  } else {
    std.debug.print("(N/A)\n", .{});
  }
}

pub fn main() !void {
  var dbm = tkrzw.DBM.open("casket.tkh", true, "") orelse return error.DBMOpenError;
  defer _ = dbm.close();

  _ = dbm.set("foo", "hop", false);
  _ = dbm.set("bar", "step", false);
  _ = dbm.set("baz", "jump", false);

  // Retrieves records.
  print_value(dbm, "foo");
  print_value(dbm, "bar");
  print_value(dbm, "baz");
  print_value(dbm, "outlier");
  
  // Traverses records.
  var iter = dbm.make_iterator();
  _ = iter.first();

  var key: []u8 = undefined;
  var value: []u8 = undefined;

  while (iter.get(&key, &value)) {
    std.debug.print("{s} {s}\n", .{key, value});
    tkrzw.free(key);
    tkrzw.free(value);
    _ = iter.next();
  }
}
