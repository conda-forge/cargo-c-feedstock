#[no_mangle]
pub extern "C" fn cargo_c_add(a: i32, b: i32) -> i32 {
    a + b
}

#[test]
fn adds_signed_integers() {
    assert_eq!(cargo_c_add(17, 25), 42);
    assert_eq!(cargo_c_add(-7, 3), -4);
}
