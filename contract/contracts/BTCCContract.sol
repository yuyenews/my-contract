// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./interface/IERC20.sol";

contract BTCCContract is IERC20 {
    // 代币名称
    string public override name;
    // 符号
    string public override symbol;
    // 小数点位数
    uint8 public override decimals = 18; // 18 is the most common number of decimal places
    //发币总量
    uint256 public override totalSupply;

    // 用mapping保存每个地址对应的余额
    mapping(address => uint256) public override balanceOf;
    // 存储对账号的控制
    mapping(address => mapping(address => uint256)) public override allowance;

    /**
     * 初始化构造
     */
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) public {
        totalSupply = initialSupply * 10**uint256(decimals); // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
        balanceOf[msg.sender] = totalSupply; // 创建者拥有所有的代币
        name = tokenName; // 代币名称
        symbol = tokenSymbol; // 代币符号
    }

    /**
     * 代币交易转移的内部实现
     */
    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        // 确保目标地址不为0x0，因为0x0地址代表销毁
        require(_to != address(0x0), "address error");
        // 检查发送者余额
        require(balanceOf[_from] >= _value, "value error");
        // 确保转移为正数个
        require(balanceOf[_to] + _value > balanceOf[_to], "value error2");

        // 以下用来检查交易，
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);

        // 用assert来检查代码逻辑。
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     *  代币交易转移
     * 从创建交易者账号发送`_value`个代币到 `_to`账号
     *
     * @param _to 接收者地址
     * @param _value 转移数额
     */
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * 账号之间代币交易转移
     * @param _from 发送者地址
     * @param _to 接收者地址
     * @param _value 转移数额
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        require(
            _value <= allowance[_from][msg.sender],
            "allowance value error"
        ); // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * 设置某个地址（合约）可以交易者名义花费的代币数。
     *
     * 允许发送者`_spender` 花费不多于 `_value` 个代币
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    // /**
    //  * 设置允许一个地址（合约）以交易者名义可最多花费的代币数。
    //  *
    //  * @param _spender 被授权的地址（合约）
    //  * @param _value 最大可花费代币数
    //  * @param _extraData 发送给合约的附加数据
    //  */
    // function approveAndCall(
    //     address _spender,
    //     uint256 _value,
    //     bytes memory _extraData
    // ) public returns (bool success) {
    //     tokenRecipient spender = tokenRecipient(_spender);
    //     if (approve(_spender, _value)) {
    //         spender.receiveApproval(msg.sender, _value, this, _extraData);
    //         return true;
    //     }
    // }

    /**
     * 销毁创建者账户中指定个代币
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "value error"); // Check if the sender has enough
        balanceOf[msg.sender] -= _value; // Subtract from the sender
        totalSupply -= _value; // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * 销毁用户账户中指定个代币
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[_from] >= _value, "value error"); // Check if the targeted balance is enough
        require(
            _value <= allowance[_from][msg.sender],
            "allowance value error"
        ); // Check allowance
        balanceOf[_from] -= _value; // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
        totalSupply -= _value; // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }
}
