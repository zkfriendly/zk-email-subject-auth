pragma circom 2.1.5;

include "@zk-email/circuits/email-verifier.circom";
include "@zk-email/circuits/utils/constants.circom";
include "@zk-email/circuits/utils/bytes.circom";
include "@zk-email/circuits/utils/regex.circom";
include "@zk-email/zk-regex-circom/circuits/common/from_addr_regex.circom";
include "./utils/commit.circom";
include "./regex/user_op_hash_regex.circom";

// Define the maximum number of bytes for the userOpHash
const MAX_USER_OP_HASH_BYTES = 64; // Adjust this based on your expected hash length

template EmailCircuit(n, k, maxHeaderBytes, txBodyMaxBytes) {
    signal input emailHeader[maxHeaderBytes];
    signal input emailHeaderLength;
    signal input pubkey[k];
    signal input signature[k];
    signal input senderEmailIdx;
    signal input userOpHashIdx;
    signal input accountCode;
    
    signal output userOpHash;
    signal output emailCommitment;
    signal output pubkeyHash;
    
    // Verify email signature
    component EV = EmailVerifier(maxHeaderBytes, 0, n, k, 1, 0, 0);
    EV.emailHeader <== emailHeader;
    EV.emailHeaderLength <== emailHeaderLength;
    EV.pubkey <== pubkey;
    EV.signature <== signature;
    pubkeyHash <== EV.pubkeyHash;

    // FROM HEADER REGEX
    signal fromRegexOut, fromRegexReveal[maxHeaderBytes];
    (fromRegexOut, fromRegexReveal) <== FromAddrRegex(maxHeaderBytes)(emailHeader);
    fromRegexOut === 1;
    signal senderEmailAddr[EMAIL_ADDR_MAX_BYTES()];
    senderEmailAddr <== SelectRegexReveal(maxHeaderBytes, EMAIL_ADDR_MAX_BYTES())(fromRegexReveal, senderEmailIdx);
    
    var numEmailAddrInts = computeIntChunkLength(EMAIL_ADDR_MAX_BYTES());
    signal senderEmailAddrInts[numEmailAddrInts] <== PackBytes(EMAIL_ADDR_MAX_BYTES())(senderEmailAddr);
    component emailAddrCommit = EmailAddrCommit(numEmailAddrInts);
    emailAddrCommit.rand <== accountCode;
    emailAddrCommit.email_addr_ints <== senderEmailAddrInts;
    emailCommitment <== emailAddrCommit.commit;

    // USER OP HASH REGEX
    signal userOpHashRegexOut, userOpHashRegexReveal[maxHeaderBytes];
    (userOpHashRegexOut, userOpHashRegexReveal) <== UserOpHashRegex(maxHeaderBytes)(emailHeader);
    userOpHashRegexOut === 1;
    signal userOpHashBytes[MAX_USER_OP_HASH_BYTES];
    userOpHashBytes <== SelectRegexReveal(maxHeaderBytes, MAX_USER_OP_HASH_BYTES)(userOpHashRegexReveal, userOpHashIdx);
    
    var numUserOpHashInts = computeIntChunkLength(MAX_USER_OP_HASH_BYTES);
    signal userOpHashInts[numUserOpHashInts] <== PackBytes(MAX_USER_OP_HASH_BYTES)(userOpHashBytes);
    userOpHash <== userOpHashInts[0]; // Adjust based on how you want to represent the hash
}
