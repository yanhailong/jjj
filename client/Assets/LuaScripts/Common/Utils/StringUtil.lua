StringUtil = { };
local this = StringUtil;

---判断字符串是否为空或者空格
function StringUtil.IsNotEmptyOrSpace(check)
    local str=tostring(check)
    return str ~= nil and str:match("^%s*(.-)%s*$") ~= ''
end

-- 将手机号中间四位屏蔽
function StringUtil.HidePhoneNumber(phoneNumber)
    local len=string.len(phoneNumber)
    if len==11 then
        return string.sub(phoneNumber, 1, 3) .. "****" .. string.sub(phoneNumber, 8, 11)
    else
        return "Invalid phonenumber"
    end
end

function StringUtil.CheckPassWork(str)
    str = tostring(str)
    if not this.CheckNumber(str) then
        return "请输入数字！"
    end
    if str == nil or string.len(str) > 6 or str=="" then
        return "请输入小于等于6位的密码"
    end
    return ""
end

--验证码是否正确
function StringUtil.CheckVerificationCode(str)
    if not StringUtil.IsNotEmptyOrSpace(str) or string.len(str)~=6 then
        return "请输入6位数验证码"
    end
    return ""
end

function StringUtil.CheckNickname(str)
    local len=StringUtil.CalcCharShowLen(str);
    if len<1 or len>12 then
        return "请设置为1到12个字符的昵称（一个中文为2个字符）"
    end
    return ""
end


-- 数字
function StringUtil.CheckNumber(str)
    return string.match(str, '%d+') == str
end

function StringUtil.CheckPhoneNumber(str)
    if str == "" then
         return "输入的手机号不能为空"
    end
    str=tostring(str)
    if string.len(str)~= 11 or tonumber(str) == nil then
    	 return "请输入11位手机号吗"
	end
    return ""
end
--==============================--
--desc:检查密码
--time:2020-06-12 12:04:51
--@str:
--@return 
--==============================--

--获取字符串显示长度 中文长度2 字母数字1
function StringUtil.CalcCharShowLen(text,limt)
    local count = 0
    local str=string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)");
    local newStr=""
    for uchar in str do
        if #uchar ~= 1 then
            count = count +2
        else
            count = count +1
        end
        newStr=newStr..uchar
        if limt then
            if count>=limt then
                break
            end
        end
    end
    return count,newStr;
end





function StringUtil.CheckBankBoxPwd(str)
    if str==nil or str=="" then
        return "密码不能为空"
    end
    local len=StringUtil.UtfStrLen(str);
    if len<3 or len>16 then
        return "密码为3到16个字符"
    end
    return ""
end



-- 邮箱
function StringUtil.CheckEmail(str)
    return string.match(str, '[%d%a]+@%a+.%a+') == str
end

-- 数字和字母
function StringUtil.CheckComplex(str)
    return(string.match(str, "%d+") == str) or(string.match(str, "^[A-Za-z]+$") == str)
end
-- 字母
function StringUtil.CheckChar(str)
    return string.match(str, "^[A-Za-z]+$") == str
end
-- 检查是否输入了中文
function StringUtil.CheckStringHasChinese(str)
    local strLen = string.len(str);
    local curByte;
    for i = 1, strLen do
        curByte = string.byte(str, i);
        log(curByte);
        local byteCount = 1;
        if curByte > 127 then
            return true;
        end
        return false;
    end
end

-- 检查是否有换行符
function StringUtil.CheckNewLine(str)
    -- "\n" + "\r\n"
    if string.match(str, "\n+") == str or string.match(str, "\r+") == str then
        return true;
    else
        return false;
    end
end
-- 检测是否有空格
function StringUtil.CheckNewSpace(str)
    -- " "
    if string.match(str, " +") == str then
        return true;
    else
        return false;
    end
end

-- 检查是否有表情
function StringUtil.CheckEmoj(str)
    if string.match(str, " %n+") == str or string.match(str, "%r+") == str then
        return false;
    else
        return true;
    end
    -- ^(?:\[[^\[\]]+\])+$
end

-- 检查中文和字母
function StringUtil.CheckCharAndChinese(str)
    return StringUtil.CheckChar(str) and StringUtil.CheckStringHasChinese(str);
end
-- 屏蔽火星文
-- function StringUtil.CheckDeleteHuoxinwen( str )
--    local resultStr = string.match(str,"\{playowner:(.+?)\}");
--    log("resultStr:"..tostring(resultStr));
-- end
-- 构造指定字符串长度字符串
function StringUtil.StructureString(numStr, bitNum)
    local tmpStr = tostring(numStr);
    local preLen = string.len(numStr);
    local lesNum = tonumber(bitNum - preLen);
    local addStr = "";
    if lesNum > 0 then
        for i = 1, lesNum do
            addStr = addStr .. "0";
        end
    end
    return addStr .. numStr;
end

-- ==============================--
-- desc: 数字转字符串
-- time:2018-04-26 05:18:01
-- @num: 数字
-- @w: nil,<0 为不做万、亿处理。
--      >=0保留几位小数
-- @return
-- ==============================--
function StringUtil.NumberFormat(num, w)
    --num = ExchangeRate(num);
    local str;
    if w and w >= 0 then
        num = tonumber(string.match(num, "%+?%-?%d+%.?%d*"));
        local t = 1;
        for i = 1, w do
            t = t * 10;
        end
        local s = "%." .. w .. "f";
        if num > 99999999 then
            num = math.floor(num /(100000000 / t));
            if num % t == 0 then
                s = "%.0f";
            end
            str = string.format(s,(num / t)) .. "亿";
            num = num *(100000000 / t);
        elseif num > 9999 then
            num = math.floor(num /(10000 / t));
            if num % t == 0 then
                s = "%.0f";
            end
            str = string.format(s,(num / t)) .. "万";
            num = num *(10000 / t);
        else
            str = tostring(num);
        end
    else
        str = tostring(num);
    end
    return str, num;
end

-- 中英文混合的字符串的长度
function StringUtil.UtfStrLen(str)
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc };
    while left ~= 0 do
        local tmp = string.byte(str, - left);
        local i = #arr;
        while arr[i] do
            if tmp >= arr[i] then left = left - i; break; end
            i = i - 1;
        end
        cnt = cnt + 1;
    end
    return cnt;
end

function string.split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end
-- 中英文混合的字符串的截取
function StringUtil.SubUTF8String(str, start, len)
    local strResult = ""
    local f = function()
        local firstResult = ""
        local maxLen = string.len(str)
        start = start - 1
        -- 找到起始位置
        local preSite = 1
        if start > 0 then
            for i = 1, maxLen do
                local s_dropping = string.byte(str, i)
                if not s_dropping then
                    local s_str = string.sub(str, preSite, i - 1)
                    preSite = i + 1
                    break
                end

                if s_dropping < 128 or(i + 1 - preSite) == 3 then
                    local s_str = string.sub(str, preSite, i)
                    preSite = i + 1
                    firstResult = firstResult .. s_str
                    local curLen = StringUtil.UtfStrLen(firstResult)
                    if (curLen == start) then
                        break
                    end
                end
            end
        end

        -- 截取字符串
        preSite = string.len(firstResult) + 1
        local startC = preSite
        for i = startC, maxLen do
            local s_dropping = string.byte(str, i)
            if not s_dropping then
                local s_str = string.sub(str, preSite, i - 1)
                preSite = i
                strResult = strResult .. s_str
                return strResult
            end

            if s_dropping < 128 or(i + 1 - preSite) == 3 then
                local s_str = string.sub(str, preSite, i)
                preSite = i + 1
                strResult = strResult .. s_str
                local curLen = StringUtil.UtfStrLen(strResult)
                if (curLen == len) then
                    return strResult
                end
            end
        end
    end
    local flag, msg = pcall(f)
    if flag then
        return strResult
    else
        return str
    end
end

-- 将空格替换成全角空格 
local space = "　"
function StringUtil.ReplaceSpace(str)
    return string.gsub(str, " ", space)
end

-- 字符串拆分
function StringUtil.Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end   

local function isEmoji(str)
    -- 编码占多少字节
    local byteLen = string.len(str)
    if byteLen > 3 then
        -- 超过三个字节的必须是emoji字符啊
        return true
    end

    if byteLen == 3 then
        if string.find(str, "[\226][\132-\173]") or string.find(str, "[\227][\128\138]") then
            return true
            -- 过滤部分三个字节表示的emoji字符，可能是早期的符号，用的还是三字节，坑。。。这里不保证完全正确，可能会过滤部分中文字。。。
        end
    end

    if byteLen == 1 then
        local ox = string.byte(str)
        if (33 <= ox and 47 >= ox) or(58 <= ox and 64 >= ox) or(91 <= ox and 96 >= ox) or(123 <= ox and 126 >= ox) or(str == "　") then
            return true
            -- 过滤ASCII字符中的部分标点，这里排除了空格，用编码来过滤有很好的扩展性，如果是标点可以直接用%p匹配。
        end
    end

    return false
end

function StringUtil.FilterEmoji(newName)
    local len = StringUtil.UtfStrLen(newName)
    local res = ""
    -- utf8解码长度
    for i = 1, len do
        local str = StringUtil.SubUTF8String(newName, i, i)
        if not isEmoji(str) then
            res = res .. str
        end
    end
    return res
end

-- 判断字符串中是否只有英文字母中文
function StringUtil.isNameLegitimacy(str)
    local strTable = { }
    local k = 1
    local changeStr = "";
    if str == nil or str == "" then
        return
    end

    while true do
        if k > #str then
            break
        end
        local c = string.byte(str, k)
        -- look(true, "    每个字符   ", c)
        if not c then
            break
        end
        if c < 192 then
            if (c >= 48 and c <= 57) or(c >= 65 and c <= 90) or(c >= 97 and c <= 122) then
                table.insert(strTable, string.char(c))
            end
            k = k + 1
        elseif c < 224 then
            k = k + 2
        elseif c < 240 then
            if c >= 228 and c <= 233 then
                local c1 = string.byte(str, k + 1)
                local c2 = string.byte(str, k + 2)
                if c1 and c2 then
                    local a1, a2, a3, a4 = 128, 191, 128, 191
                    if c == 228 then
                        a1 = 184
                    elseif c == 233 then
                        a2, a4 = 190, c1 ~= 190 and 191 or 165
                    end
                    if c1 >= a1 and c1 <= a2 and c2 >= a3 and c2 <= a4 then
                        table.insert(strTable, string.char(c, c1, c2))
                    end
                end
            end
            k = k + 3
        elseif c < 248 then
            k = k + 4
        elseif c < 252 then
            k = k + 5
        elseif c < 254 then
            k = k + 6
        end
    end

    if #strTable > 0 then
        for i = 1, #strTable do

            changeStr = changeStr .. strTable[i]
        end
    else
        return false;
    end

    look(true, "#strTable", #strTable, strTable, #str, str, "changeStr", #changeStr, changeStr)
    if #changeStr == #str then
        return true
    end
    return false
end  

function StringUtil.ToComma(num)
    num = tonumber(num);
    local str = "";
    local tmp =(num % 1000);
    num = math.floor(num / 1000);
    while num > 0 do
        str = "," .. string.format("%03d", tmp) .. str;
        tmp =(num % 1000);
        num = math.floor(num / 1000);
    end
    return tmp .. str;
end

-- "num">要轉換的數字
--- fixeds"需要幾位小數
-- 超过10亿会出现科学计数法  导致数据出错
function StringUtil.commafy(num)
    if num==nil or num<=0 then
        return 0
    else
    num = tonumber(num);
    local str = "";
    local tmp =(num % 1000);
    num = math.floor(num / 1000);
    while num > 0 do
        str = "." .. string.format("%03d", tmp) .. str;
        tmp =(num % 1000);
        num = math.floor(num / 1000);
    end
    return tmp .. str;
    end

end 

-- ==============================--
-- desc: num 转 美术字 （优化mat的美术字符集）
-- time:2018-04-26 04:46:12
-- @num: 传入数字
-- @index: 第几套
-- @return Text.text
-- ==============================--
function StringUtil.NumberToText(str, index)
    if ChannelVersionSwitch.RMBCheck() then
        str = string.gsub(str,"%$","")
    end
    str = ExchangeRate(str);
    local j = string.find(str, "J", 1);
    str = string.gsub(str, "亿", string.char(34));
    str = string.gsub(str, "万", string.char(33));
    str = string.gsub(str, "億", string.char(34));
    str = string.gsub(str, "萬", string.char(33));
    -- str = StringUtil.formatnumberthousands(str)
    index = index - 2;
    local ret = "";
    for i = 1, #str do
        if i == j then
            ret = ret .. string.char(1);
        else
            ret = ret .. utf8.byte2utf8(string.byte(str, i) + index * 32);
        end
    end
    return ret;
end
--不需要比例转换的方法
function StringUtil.NumberToText2(str, index)
    if ChannelVersionSwitch.RMBCheck() then
        str = string.gsub(str,"%$","")
    end
    local j = string.find(str, "J", 1);
    str = string.gsub(str, "亿", string.char(34));
    str = string.gsub(str, "万", string.char(33));
    str = string.gsub(str, "億", string.char(34));
    str = string.gsub(str, "萬", string.char(33));
    -- str = StringUtil.formatnumberthousands(str)
    index = index - 2;
    local ret = "";
    for i = 1, #str do
        if i == j then
            ret = ret .. string.char(1);
        else
            ret = ret .. utf8.byte2utf8(string.byte(str, i) + index * 32);
        end
    end

    return ret;
end

function StringUtil.NumberToBig(number)    
    assert(tonumber(number), "传入参数非正确number类型！")    
    local numerical_tbl = {}    
    local numerical_names = {[0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}    
    local numerical_units = {"", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "兆", "拾", "佰", "仟"}     
    --01，数字转成表结构存储    
    local numerical_length = string.len(number)    
    for i = 1, numerical_length do	
        numerical_tbl[i] = tonumber(string.sub(number, i, i))    
    end     
    --02，对应数字转中文处理    
    local result_numberical = ""    
    local to_append_zero, need_filling = false, true    
    for index, number in ipairs(numerical_tbl) do	
        --从高位到底位的顺序数字转成对应的从低位到高位的顺序数字单位.	
        local real_unit_index = numerical_length - index + 1	
        if number == 0 then	   
            if need_filling then	      
                if real_unit_index == 5 then
                    --万位		 
                    result_numberical = result_numberical .. "万"		 
                    need_filling = false	      
                end	      
                if real_unit_index == 9 then
                    --亿位		 
                    result_numberical = result_numberical .. "亿"		 
                    need_filling = false	      
                end	      
                if real_unit_index == 13 then
                    --兆位		 
                    result_numberical = result_numberical .. "兆"		 
                    need_filling = false	      
                end	   
            end	   
            to_append_zero = true        
        else	   
            if to_append_zero then	      
                result_numberical = result_numberical .. "零"	      
                to_append_zero = false           
            end	   
            result_numberical = result_numberical  .. numerical_names[number] .. numerical_units[real_unit_index]	   
            if real_unit_index == 5 or real_unit_index == 9 or real_unit_index == 13 then		
                need_filling = false	   
            else		
                need_filling = true	   
            end	
        end    
	end
	if result_numberical=="" or result_numberical==nil then
		return "零"
	end
    return result_numberical
end
















-----------------------------------------------------------------------------------------







function StringUtil.formatnumberthousands(num)

    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end 

function StringUtil.numbertoformat(num, deperator)
    local str1 = ""
    local str = tostring(num)
    local strLen = string.len(str)
    if deperator == nil then
        deperator = ","
    end
    deperator = tostring(deperator)

    for i = 1, strLen do
        str1 = string.char(string.byte(str, strLen + 1 - i)) .. str1
        if math.mod(i, 3) == 0 then
            -- 下一个数 还有
            if strLen - i ~= 0 then
                str1 = "," .. str1
            end
        end
    end

    return str1
end
local hzUnit = { "", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "万", "十", "百", "千" }
local hzNum = { "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" }
function StringUtil.numberTooString(szNum)
    --- 阿拉伯数字转中文大写
    local szChMoney = ""
    local iLen = 0
    local iNum = 0
    local iAddZero = 0

    if nil == tonumber(szNum) then
        return tostring(szNum)
    end
    iLen = string.len(szNum)
    if iLen > 10 or iLen == 0 or tonumber(szNum) < 0 then
        return tostring(szNum)
    end
    for i = 1, iLen do
        iNum = string.sub(szNum, i, i)
        if iNum == 0 and i ~= iLen then
            iAddZero = iAddZero + 1
        else
            if iAddZero > 0 then
                szChMoney = szChMoney .. hzNum[1]
            end
            szChMoney = szChMoney .. hzNum[iNum + 1]
            -- //转换为相应的数字
            iAddZero = 0
        end
        if (iAddZero < 4) and(0 ==(iLen - i) % 4 or 0 ~= tonumber(iNum)) then
            szChMoney = szChMoney .. hzUnit[iLen - i + 1]
        end
    end

    return StringUtil.RemoveZero(szChMoney)
end
 function StringUtil.RemoveZero(num)
    -- 去掉末尾多余的 零
    num = tostring(num)
    local szLen = string.len(num)
    local zero_num = 0
    for i = szLen, 1, -3 do
        szNum = string.sub(num, i - 2, i)
        if szNum == hzNum[1] then
            zero_num = zero_num + 1
        else
            break
        end
    end
    num = string.sub(num, 1, szLen - zero_num * 3)
    szNum = string.sub(num, 1, 6)
    --- 开头的 "一十" 转成 "十" 
    if szNum == hzNum[2] .. hzUnit[2] then
        num = string.sub(num, 4, string.len(num))
    end
    num = string.gsub(num, "零零零", "零")
    num = string.gsub(num, "零零", "零")
    num = string.gsub(num, "零万", "万")
    num = string.gsub(num, "亿万", "亿")
    num = string.gsub(num, "零亿", "亿")
    return num
end

function StringUtil.decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function StringUtil.encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end
function StringUtil.secondsToTime(ts)
    local sec=math.floor(ts/60)
    local ms=ts-sec*60
    return sec..":"..string.format("%02d", ms);
end

--获取字符串长度，数字，字母，汉字都视为1
function StringUtil.getStringLength(inputstr)
    if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
        return nil
    end
    local length = 0  -- 字符的个数
    local i = 1
    while true do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte > 239 then
            byteCount = 4  -- 4字节字符
        elseif curByte > 223 then
            byteCount = 3  -- 汉字
        elseif curByte > 128 then
            byteCount = 2  -- 双字节字符
        else 
            byteCount = 1  -- 单字节字符
        end
        --local char = string.sub(inputstr, i, i + byteCount - 1)
        --print(char)  -- 打印单个字符
        i = i + byteCount
        length = length + 1
        if i > #inputstr then
            break
        end
    end
    return length
end

-- 替换字符串的占位符 {0},{1},...
function StringUtil.formatString(format, ...)
    local str = format
    local args = {...}
    for i = 1, #args do
        local index = i -1
        str = string.gsub(str, "{".. index .. "}", args[i])
    end
    return str
end

---数字处理  K（千）、M（百万）、B（十亿）、T（万亿）、P（千万亿）、E（百亿亿）‌、Z十万亿亿）、Y（亿亿亿）
---@param number底注数字
---@param decimals小数位数默认0
function StringUtil.FormatNumber(number,decimals)
    assert(tonumber(number), "传入参数非正确number类型！")
    decimals = decimals or 0
    local units = {"", "K", "M", "B", "T", "P", "E", "Z", "Y"}
    local unitIndex = 1
    while number >= 1000 and unitIndex < #units do
        number = number / 1000
        unitIndex = unitIndex + 1
    end
    return string.format( "%."..decimals.."f%s", number, units[unitIndex])
end 