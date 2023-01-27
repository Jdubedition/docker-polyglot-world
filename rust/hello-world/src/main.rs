use gethostname::gethostname;
use hyper::header::{HeaderValue, CONTENT_TYPE};
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};
use rand::Rng;
use serde::{Deserialize, Serialize};
use std::convert::Infallible;
use std::fs;
use std::net::SocketAddr;

#[derive(Serialize, Deserialize)]
struct Greeting {
    language: String,
    greeting: String,
}

async fn hello_world(_req: Request<Body>) -> Result<Response<Body>, Infallible> {
    let contents = match fs::read_to_string("../../hello-world.json") {
        Ok(contents) => contents,
        Err(e) => {
            println!("ERROR: {}", e);
            let response = Response::builder()
                .status(hyper::StatusCode::INTERNAL_SERVER_ERROR)
                .body(Body::empty())
                .unwrap();
            return Ok(response);
        }
    };
    // let greetings: Vec<Greeting> = serde_json::from_str(&contents).unwrap();
    let greetings: Vec<Greeting> = match serde_json::from_str(&contents) {
        Ok(greetings) => greetings,
        Err(e) => {
            println!("ERROR: {}", e);
            let response = Response::builder()
                .status(hyper::StatusCode::INTERNAL_SERVER_ERROR)
                .body(Body::empty())
                .unwrap();
            return Ok(response);
        }
    };
    let rand_index = rand::thread_rng().gen_range(0..greetings.len());
    let rand_greeting = &greetings[rand_index];
    let response_body = format!(
        "{{\"language\":\"{}\", \"greeting\":\"{}\", \"from\":{:?}, \"implementation\":\"Rust\"}}",
        rand_greeting.language,
        rand_greeting.greeting,
        gethostname()
    );
    let mut response = Response::new(response_body.into());
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
    println!("INFO: starting hello-world server");
    // We'll bind to 127.0.0.1:8080
    let addr = SocketAddr::from(([0, 0, 0, 0], 8080));

    // A `Service` is needed for every connection, so this
    // creates one from our `hello_world` function.
    println!("INFO: creating service");
    let make_svc = make_service_fn(|_conn| async {
        // service_fn converts our function into a `Service`
        Ok::<_, Infallible>(service_fn(hello_world))
    });

    println!("INFO: starting server");
    let server = Server::bind(&addr).serve(make_svc);

    println!("INFO: server running on {}", addr);
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
        assert!(result.contains("\"language\":"));
        assert!(result.contains("\"greeting\":"));
        assert!(result.contains("\"from\":"));
    }
}
