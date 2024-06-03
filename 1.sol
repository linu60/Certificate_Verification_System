/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateRegistry {
    struct Certificate {
        uint256 id;
        string name;
        address issuer;
        uint256 certificateId;
        string date;
        string purpose;
    }

    mapping(uint256 => Certificate) public certificates;

    event CertificateCreated(uint256 indexed id, string name, address indexed issuer, uint256 indexed certificateId, string date, string purpose);

    function createCertificate(string memory _name, uint256 _certificateId, string memory _date, string memory _purpose) public returns (uint256) {
        uint256 certificateId = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        require(certificates[certificateId].id == 0, "Certificate with this ID already exists");

        Certificate memory newCertificate = Certificate({
            id: certificateId,
            name: _name,
            issuer: msg.sender,
            certificateId: _certificateId,
            date: _date,
            purpose: _purpose
        });

        certificates[certificateId] = newCertificate;

        emit CertificateCreated(certificateId, _name, msg.sender, _certificateId, _date, _purpose);
        return certificateId;
    }

    function verifyCertificate(uint256 _idToVerify) public view returns (uint256,bool) {
        Certificate memory cert = certificates[_idToVerify];

        if (cert.id == 0 || cert.issuer != msg.sender) {
            return (0,false);
        }

        return (_idToVerify,true);
    }

    function getAllCertificates() public view returns (uint256[] memory) {
        uint256[] memory allCertificateIds = new uint256[](block.number);
        uint256 count = 0;

        for (uint256 i = 1; i <= block.number; i++) {
            if (certificates[i].id != 0) {
                allCertificateIds[count] = certificates[i].id;
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        for (uint256 j = 0; j < count; j++) {
            result[j] = allCertificateIds[j];
        }

        return result;
    }
}