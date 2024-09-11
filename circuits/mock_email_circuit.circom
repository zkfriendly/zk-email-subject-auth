pragma circom 2.1.5;

include "@zk-email/circuits/email-verifier.circom";
include "@zk-email/circuits/utils/constants.circom";
include "@zk-email/circuits/utils/bytes.circom";
include "@zk-email/circuits/utils/regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/from_addr_regex.circom";
include "./utils/commit.circom";

// Mock contract that constraints the output to inputs
// * n - the number of bits in each chunk of the RSA public key (modulust)
// * k - the number of chunks in the RSA public key (n * k > 2048)
// * maxHeaderBytes - max number of bytes in the email header
// * txBodyMaxBytes - max number of bytes in the tx body
template MockEmailCircuit(n, k, maxHeaderBytes, txBodyMaxBytes) {
    signal input emailHeader[maxHeaderBytes];
    signal input emailHeaderLength;
    signal input pubkey[k];
    signal input signature[k];
    signal input senderEmailIdx;
    signal input accountCode;

    signal input userOpHashIn;
    signal input emailCommitmentIn;
    signal input pubkeyHashIn;

    signal output userOpHash;
    signal output emailCommitment;
    signal output pubkeyHash;

    userOpHash <== userOpHashIn;
    emailCommitment <== emailCommitmentIn;
    pubkeyHash <== pubkeyHashIn;
}