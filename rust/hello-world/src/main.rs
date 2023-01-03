use gethostname::gethostname;
use hyper::header::{HeaderValue, CONTENT_TYPE};
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
use std::convert::Infallible;
use std::net::SocketAddr;

async fn hello_world(_req: Request<Body>) -> Result<Response<Body>, Infallible> {
    println!("INFO: received request");
    let mut response =
        Response::new(format!("{{\"hello\":\"World\", \"from\":{:?}}}", gethostname()).into());
    response
        .headers_mut()
        .insert(CONTENT_TYPE, HeaderValue::from_static("application/json"));
    Ok(response)
}

async fn shutdown_signal() {
    // Wait for the CTRL+C signal
    tokio::signal::ctrl_c()
        .await
        .expect("failed to install CTRL+C signal handler");
}

#[tokio::main]
async fn main() {
    // We'll bind to 127.0.0.1:8080
    let addr = SocketAddr::from(([0, 0, 0, 0], 8080));

    // A `Service` is needed for every connection, so this
    // creates one from our `hello_world` function.
    let make_svc = make_service_fn(|_conn| async {
        // service_fn converts our function into a `Service`
        Ok::<_, Infallible>(service_fn(hello_world))
    });

    let server = Server::bind(&addr).serve(make_svc);

    // And now add a graceful shutdown signal...
    let graceful = server.with_graceful_shutdown(shutdown_signal());

    // Run this server for... forever!
    if let Err(e) = graceful.await {
        eprintln!("server error: {}", e);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use hyper::{Body, Request, StatusCode};

    #[tokio::test]
    async fn test_hello_world() {
        let req = Request::new(Body::empty());
        let res = hello_world(req).await.unwrap();

        assert_eq!(res.status(), StatusCode::OK);
        let body: Body = res.into_body();
        let bytes = hyper::body::to_bytes(body).await.unwrap();
        let result = String::from_utf8(bytes.into_iter().collect()).expect("");
        assert!(result.contains("hello"));
        assert!(result.contains("World"));
        assert!(result.contains("from"));
    }
}
