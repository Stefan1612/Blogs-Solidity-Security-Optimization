// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract gasOptimizationONE {
    uint[] public array = [1,2,3,4,5,6,7];
    uint public num;
    
    function versionOne() external{
        for (uint i = 0; i < array.length; i++){
        num = num + array[i];
        }   
    }

    function versionTwo() external {
        uint _num;
        for (uint i = 0; i < array.length; i++){
            _num = _num + array[i];
        }
        num = _num;
    }

    function versionThree() external {
        uint _num;
        uint[] memory _array = array;
        for (uint i = 0; i < array.length; i++){
            _num = _num + _array[i];
        }
        num = _num;
    }

}
