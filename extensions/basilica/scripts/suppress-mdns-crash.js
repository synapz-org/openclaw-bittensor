// Fix for Kubernetes: override os.hostname() to return a short name
// K8s pod hostnames (e.g. "609f4e89-587d-4c4c-9630-906b2c241174-deployment-75f4c5c7d9gswkk")
// exceed the 63-byte DNS label limit that @homebridge/ciao requires for mDNS,
// causing an uncaught AssertionError that crashes the OpenClaw gateway.
const os = require('os');
const originalHostname = os.hostname;
os.hostname = function() {
  const name = originalHostname.call(os);
  if (name.length > 63) {
    return name.substring(0, 12);
  }
  return name;
};
