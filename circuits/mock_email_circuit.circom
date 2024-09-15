pragma circom 2.1.6;

// Mock contract that constraints the output to inputs
template MockEmailCircuit() {
    signal input userOpHashIn;
    signal input emailCommitmentIn;
    signal input pubkeyHashIn;
    
    signal dummy <== 1;

    signal output userOpHash;
    signal output emailCommitment;
    signal output pubkeyHash;

    userOpHash <== dummy * userOpHashIn;
    emailCommitment <== dummy * emailCommitmentIn;
    pubkeyHash <== dummy * pubkeyHashIn;
}