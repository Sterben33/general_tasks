pragma ton-solidity >=0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import './resolvers/IndexResolver.sol';
import './resolvers/DataResolver.sol';

import './IndexBasis.sol';

import './interfaces/IData.sol';
import './interfaces/IIndexBasis.sol';
import './libraries/Common.sol';




contract NftRoot is DataResolver, IndexResolver {
    
    uint8 constant RARNESS_DOES_NOT_EXIST = 110; 
    uint8 constant LIMIT_EXCEEDED = 111; 
    
    uint256 _totalMinted;
    address _addrBasis;

    mapping (string=>uint) _rarenessToLimit;
    mapping (string=>uint) _rarenessToMintedCount;

    uint _limit;
    constructor(TvmCell codeIndex, TvmCell codeData, Rareness[] rarenessTypeList, uint limit) public {
        tvm.accept();
        _codeIndex = codeIndex;
        _codeData = codeData;
        for(uint i; i < rarenessTypeList.length; i++) {
            Rareness r = rarenessTypeList[i];
            _rarenessToLimit[r.name] = r.maxCount;
        }
        _limit = limit;
    }

    function mintNft(string rarenessName) public {
        require(_rarenessToLimit.exists(rarenessName), RARNESS_DOES_NOT_EXIST);
        if(!_rarenessToMintedCount.exists(rarenessName)) {
            _rarenessToMintedCount[rarenessName] = 0;
        }
        require(
            _rarenessToLimit[rarenessName] > _rarenessToMintedCount[rarenessName] &&
            _limit > _rarenessToMintedCount[rarenessName],
            LIMIT_EXCEEDED
        );
        
        TvmCell codeData = _buildDataCode(address(this));
        TvmCell stateData = _buildDataState(codeData, _totalMinted);
        new Data{stateInit: stateData, value: 1.1 ton}(msg.sender, _codeIndex, rarenessName);

        _totalMinted++;
    }

    function deployBasis(TvmCell codeIndexBasis) public {
        require(msg.value > 0.5 ton, 104);
        uint256 codeHasData = resolveCodeHashData();
        TvmCell state = tvm.buildStateInit({
            contr: IndexBasis,
            varInit: {
                _codeHashData: codeHasData,
                _addrRoot: address(this)
            },
            code: codeIndexBasis
        });
        _addrBasis = new IndexBasis{stateInit: state, value: 0.4 ton}();
    }

    function destructBasis() public view {
        IIndexBasis(_addrBasis).destruct();
    }
}