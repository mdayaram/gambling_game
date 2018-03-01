pragma solidity ^0.4.19;

contract GamblingGame {
    struct Player {
        address payout;
        bytes32 commit;
        uint revealed;
    }
    
    uint playersRevealed;
    Player[] players;
    
    
    function EnterGame(bytes32 _commit) public payable {
        require(msg.value == 1 ether);
        
        address _player = msg.sender;
        
        require(players.length <= 1);
        
        if (players.length == 0) {
            players.push(Player(_player, _commit, 0));
        } else {
            require(players[0].payout != _player);
            players.push(Player(_player, _commit, 0));
        }
    }
    
    function RevealCommit(uint _index, uint _nonce, uint _number) public {
        address _player = msg.sender;
        _index = _index % 2;
        
        require(uint(_nonce) != 0);
        require(players[_index].payout == _player);
        require(Keccac(_index, _nonce, _number) == players[_index].commit);
        
        players[_index].revealed = _number;
        
        playersRevealed++;
        
        if (playersRevealed == 2) {
            uint sum = players[0].revealed + players[1].revealed;
            uint winner = sum % 2;
            players[winner].payout.transfer(2 ether);
        }
    }
    
    function Keccac(uint _index, uint _nonce, uint _number) public pure returns(bytes32) {
        return keccak256(_index, _nonce, _number);
    }
    
}
