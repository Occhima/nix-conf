let
  yubiPublicKey = "age1yubikey1qtamcxf9cwyhh6emf6ffn06ndvr5v4u8trz4dfsryn4rkt38pewxy5w3lfk";
in
{
  "vault/test.age".publicKeys = [
    yubiPublicKey
  ];
}
