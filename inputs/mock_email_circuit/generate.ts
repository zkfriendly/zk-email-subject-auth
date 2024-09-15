import fs from "fs";
import { promisify } from "util";
import { generateEmailVerifierInputs } from "@zk-email/helpers";

export const EMAIL_HEADER_MAX_BYTES = 1024;

export type MockEmailCircuitInput = {
  accountCode: string;
  userOpHashIn: string;
  emailCommitmentIn: string;
  pubkeyHashIn: string;
};

export async function getInputs(
  emailFilePath: string
): Promise<MockEmailCircuitInput> {
  
  const inputs: MockEmailCircuitInput = {
    accountCode: "1",
    userOpHashIn: "2",
    emailCommitmentIn: "3",
    pubkeyHashIn: "4",
  };

  return inputs;
}

export async function generate(emailFilePath: string) {
  const inputs = await getInputs(emailFilePath);

  // write to default.json file
  const outputFilePath = emailFilePath.replace(".eml", ".json");
  await promisify(fs.writeFile)(
    outputFilePath,
    JSON.stringify(inputs, null, 2)
  );
}
