// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract EduChainCredential {

    // ==========================================
    // Credential Structure
    // ==========================================

    struct Credential {
        string credentialId;
        bytes32 certificateHash;
        address issuer;
        uint256 issueDate;
        bool revoked;
        bool exists;
    }

    // ==========================================
    // Storage
    // ==========================================

    mapping(string => Credential) private credentials;

    // ==========================================
    // Events
    // ==========================================

    event CredentialIssued(
        string credentialId,
        bytes32 certificateHash,
        address indexed issuer,
        uint256 issueDate
    );

    event CredentialRevoked(
        string credentialId,
        address indexed issuer,
        uint256 revokeDate
    );

    // ==========================================
    // Issue Credential
    // ==========================================

    function issueCredential(
        string memory _credentialId,
        bytes32 _certificateHash
    ) external {

        require(
            bytes(_credentialId).length > 0,
            "Credential ID is required"
        );

        require(
            _certificateHash != bytes32(0),
            "Certificate hash is required"
        );

        require(
            !credentials[_credentialId].exists,
            "Credential already exists"
        );

        credentials[_credentialId] = Credential({
            credentialId: _credentialId,
            certificateHash: _certificateHash,
            issuer: msg.sender,
            issueDate: block.timestamp,
            revoked: false,
            exists: true
        });

        emit CredentialIssued(
            _credentialId,
            _certificateHash,
            msg.sender,
            block.timestamp
        );
    }

    // ==========================================
    // Verify Credential
    // ==========================================

    function verifyCredential(
        string memory _credentialId,
        bytes32 _certificateHash
    ) external view returns (bool) {

        Credential memory credential =
            credentials[_credentialId];

        if (!credential.exists) {
            return false;
        }

        if (credential.revoked) {
            return false;
        }

        if (credential.certificateHash != _certificateHash) {
            return false;
        }

        return true;
    }

    // ==========================================
    // Get Credential Details
    // ==========================================

    function getCredential(
        string memory _credentialId
    )
        external
        view
        returns (
            string memory credentialId,
            bytes32 certificateHash,
            address issuer,
            uint256 issueDate,
            bool revoked,
            bool exists
        )
    {
        Credential memory credential =
            credentials[_credentialId];

        return (
            credential.credentialId,
            credential.certificateHash,
            credential.issuer,
            credential.issueDate,
            credential.revoked,
            credential.exists
        );
    }

    // ==========================================
    // Revoke Credential
    // ==========================================

    function revokeCredential(
        string memory _credentialId
    ) external {

        Credential storage credential =
            credentials[_credentialId];

        require(
            credential.exists,
            "Credential does not exist"
        );

        require(
            credential.issuer == msg.sender,
            "Only issuer can revoke"
        );

        require(
            !credential.revoked,
            "Credential already revoked"
        );

        credential.revoked = true;

        emit CredentialRevoked(
            _credentialId,
            msg.sender,
            block.timestamp
        );
    }
}