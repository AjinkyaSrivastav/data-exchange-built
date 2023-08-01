//SPDX-License-Identifier: MIT 

contract transaction
{
    uint CAcounter; 
    uint DHPcounter; 

constructor() public 
{
    CAcounter=0;
    DHPcounter=0; 
}

struct cipherAssociation 
{
    uint identifier; 
    address issuer;
    string cipher; 
    address[] accessPool;
}
struct diffieHellmanPool 
{
    uint identifier;
    uint exchangeCounter; 
    address issuer;
    uint prime;
    uint generator;
    uint exhanges; 
    address[] accessPool;
}
struct publicKeyPool 
{
    uint identifier;
    uint publicKey; 
    address[] accessPool;
}
cipherAssociation[] private CA;
diffieHellmanPool[] private DHP;

mapping(address=> publicKeyPool[]) private PKP;
mapping(address=> uint) private PKI;

function storeCipher(string memory cipher, address[] memory parties) public
returns(uint) 
{
    cipherAssociation memory c=cipherAssociation(CAcounter, msg.sender, cipher, parties);
    CA.push(c); 
    CA[CAcounter].accessPool.push(msg.sender); 
    uint id=CAcounter;
    CAcounter++;
    return id;
}
function addAccessorCipher(uint identifier, address[] memory parties) public returns(bool)
{
    cipherAssociation storage c=CA[identifier]; 
    bool flag=false;
    if(c.issuer==msg.sender)
        {
        flag==true;
        for(uint i=0;i<parties.length;i++) 
            {
            c.accessPool.push(parties[i]); 
            }
        }
    return flag;
}
function retrieveCipher(uint identifier) public view returns(string memory) 
{
    cipherAssociation memory c=CA[identifier]; 
    for(uint i=0;i<c.accessPool.length;i++)
    {
        if(c.accessPool[i]==msg.sender) 
        {
        return c.cipher; 
        }
    }
    return "0"; 
}
function createNewDHExchange(uint prime, uint generator, uint exchange, address[] memory parties) public returns(uint)
{
    diffieHellmanPool memory d=diffieHellmanPool(DHPcounter, 0, msg.sender,prime, generator, exchange, parties); 
    DHP .push(d);
    DHP[DHPcounter].accessPool.push(msg.sender); uint id=DHPcounter;
    DHPcounter++;
    return id;
}
function addDHEexchange(uint identifier, uint exchange) public returns(bool) 
{
    bool flag=false;
    for(uint i=0;i<DHP[identifier].accessPool.length;i++) 
    {
        if(DHP[identifier].accessPool[i]==msg.sender) 
        {
            DHP[identifier].exhanges = exchange;
            flag=true; 
        }
    }
    return flag; 
}
function addAccessorDH(uint identifier, address[] memory parties) public returns(bool) 
    {
    bool flag = false;
    if(DHP[identifier].issuer == msg.sender) 
        {
        for(uint i=0;i<parties.length;i++) 
        { 
            DHP[identifier].accessPool.push(parties[i]);
        }
        flag = true; 
    }
    return flag; 
}
function getDHExchange(uint identifier) public view returns(uint) 
{
    for(uint i=0;i<DHP[identifier].accessPool.length;i++) 
        {
            if(DHP[identifier].accessPool[i]==msg.sender) 
            {
                return DHP[identifier].exhanges; 
            }
        }
        return 0; 
}
function createNewKeyPool(uint pubK, address[] memory parties) public returns(uint)
{
    uint identifier=PKI[msg.sender];
    PKI[msg.sender]=identifier+1;
    publicKeyPool memory p=publicKeyPool(identifier, pubK, parties); publicKeyPool[] storage keyPool=PKP[msg.sender]; 
    keyPool.push(p);
    keyPool[identifier].accessPool.push(msg.sender); 
    PKP[msg.sender]=keyPool;
    return identifier;
}
function getPubKfromKeyPool(address party, uint identifier) public view returns(uint)
    {
        if(PKI[party]>=identifier) 
        {   
            return 0; 
        }
        for(uint i=0;i<PKP[party][identifier].accessPool.length;i++) 
            {
                if(PKP[party][identifier].accessPool[i]==msg.sender) 
                    {
                        return PKP[party][identifier].publicKey;
                    } 
            }
            return 0; 
        }
}
