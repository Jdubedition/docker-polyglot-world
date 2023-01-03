// This test requires the application to be running, as it will only
// have access to the public interface of the application.
// After starting application: cargo run
// Run this test with: cargo test -- --ignored

use hyper::{Body, Client, StatusCode, Uri};
use tokio::runtime::Runtime;

#[test]
#[ignore]
fn test_hello_world() {
    let rt = Runtime::new().unwrap();
    let client = Client::new();

    let uri: Uri = "http://127.0.0.1:8080/".parse().unwrap();
    let req = client.get(uri);
    let res = rt.block_on(req).unwrap();

    assert_eq!(res.status(), StatusCode::OK);
    let body: Body = res.into_body();
    let bytes = rt.block_on(hyper::body::to_bytes(body)).unwrap();
    let result = String::from_utf8(bytes.into_iter().collect()).expect("");
    assert!(result.contains("hello"));
    assert!(result.contains("World"));
    assert!(result.contains("from"));
}
