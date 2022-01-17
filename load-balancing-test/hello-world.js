const msg = process.argv[2];

function hello ( msg="World" ) {
  console.log(`Hello ${msg}`);
}

hello(msg);