import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EduChainCredentialModule = buildModule(
    "EduChainCredentialModule",
    (m) => {
        const credential = m.contract("EduChainCredential");

        return {
            credential,
        };
    }
);

export default EduChainCredentialModule;