# Token 认证步骤

## 1. ECOLOGY系统配置
### 1.1 配置接口白名单
在ecology系统代码目录中找到以下配置文件：`ecology/WEB-INF/prop/weaver_session_filter.properties`

```properties
checkurl=/api/hrm/emmanager;/api/userPhrase;
uncheckurl=/api/ec/dev/app/getCheckSystemInfo;/api/ec/dev/app/emjoin;
unchecksessionurl=/api/ec/dev/util/accesspage;/api/workflow/emAppCount/doingCount;/api/sms/
base/sendSms;/api/integration/simplesso/hasSession;/***此处省略****/;/api/edc/fillin/;
```
在 `unchecksessionurl=` 后面添加`/api/ec/dev/auth/regist;/api/ec/dev/auth/applytoken;`

### 1.2 发放许可证(appid) 在ecology系统数据库执行以下脚本示例

```
INSERT INTO ECOLOGY_BIZ_EC(ID,APPID,NAME) VALUES("123456","EEAA5436-7577-4BE0-8C6C89E9D88805EA","上海泛微网络科技股份有限公司");
```

字段描述：

- `ID`：数据库主键。保证与其它系统发放的许可证在数据库中的主键标识不冲突即可( 对应示例：123456 ）
- `APPID`：许可证号码。最终发放给异构系统的许可证号码,多个许可证号码保证唯一(对应示例：EEAA5436-7577-4BE0-8C6C-89E9D88805EA)
- `NAME`：许可证名称。用于快速辨识许可证发放系统(对应示例：上海泛微网络科技股份有限公司)

## 2. `RSA` 算法

```java
package com.engine.wcode.token;

import javax.crypto.Cipher;
import java.security.*;
import java.security.spec.X509EncodedKeySpec;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: Y-Aron
 * @create: 2018-10-30 00:10
 **/
public class RSA {

    private static final String KEY_ALGORITHM = "RSA";

    private static final int INIT_SIZE = 1024;

    private static final String PUBLIC_KEY = "RSAPublicKey";
    private static final String PRIVATE_KEY = "RSAPrivateKey";
    private static final String SIGNATURE_ALGORITHM = "MD5withRSA";

    private static final Map<String, String> KEY_MAP = new HashMap<>(2);

    static {
        KeyPairGenerator keyPairGen = null;
        try {
            keyPairGen = KeyPairGenerator.getInstance(KEY_ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        if (keyPairGen != null) {
            keyPairGen.initialize(INIT_SIZE);
            KeyPair keyPair = keyPairGen.generateKeyPair();
            // 公钥
            KEY_MAP.put(PUBLIC_KEY, Base64Utils.encodeToString(keyPair.getPublic().getEncoded()));
            // 私钥
            KEY_MAP.put(PRIVATE_KEY, Base64Utils.encodeToString(keyPair.getPrivate().getEncoded()));
        }
    }

    /**
     * 取得私钥
     */
    public static String getPrivateKey(){
        return KEY_MAP.get(PRIVATE_KEY);
    }

    /**
     * 取得公钥
     */
    public static String getPublicKey(){
        return KEY_MAP.get(PUBLIC_KEY);
    }

    /**
     * 公钥加密
     * @param data 需要加密的数据
     * @param publicKey 公钥
     * @return 加密后的字节数组
     */
    public static byte[] encrypt(String data, String publicKey) {
        try {
            // 对公钥解密
            byte[] keyBytes = Base64Utils.decode(publicKey);
            // 取得公钥
            X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(keyBytes);
            KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
            Key key = keyFactory.generatePublic(x509KeySpec);
            // 对数据加密
            Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
            cipher.init(Cipher.ENCRYPT_MODE, key);
            return cipher.doFinal(data.getBytes());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
```

## 3. `Base64`算法

```java
package com.engine.wcode.token;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * @author Y-Aron
 * @create 2019/7/26 19:06
 * @since 1.0.0
 */
public class Base64Utils {

    public static String encodeToString(final String src) {
        final Base64.Encoder encoder = Base64.getEncoder();
        return encoder.encodeToString(src.getBytes(StandardCharsets.UTF_8));
    }

    public static String encodeToString(final byte[] src) {
        final Base64.Encoder encoder = Base64.getEncoder();
        return encoder.encodeToString(src);
    }

    public static byte[] decode(String publicKey) {
        Base64.Decoder decoder = Base64.getDecoder();
        return decoder.decode(publicKey);
    }
}
```

## 4. 认证代码案例

```java
package com.engine.wcode.token;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * @author Y-Aron
 * @create 2019/7/26 21:03
 * @since 1.0.0
 */
public class TestToken {

    private static final String APP_ID = "1";

    private static final Logger logger = LoggerFactory.getLogger("debug");

    public void testApi() throws IOException {
        // 普通接口调用
        String spk = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgChcR0w1oEha8aKEVM+DW6Fa0ne7Ezi+hL4yhAiqF9PO/eiFso5DbnFK/Dixh9OhS+UrDFLmmx/LLrO1sbx17mu6ZeW5t2qu9F4wGSncQlhq3qle9Sb45G/4zoqRhXXGzy7dSPMGxWomE/DQkcC7pfkOXvpaBAkMq0GZu+6brtVWYcKzimZxZFwRf/iVSaEL55Ky/zDzD17w/q4+s6+S++YDsqdtQAsV1plBoA2aCzBy8BuppkeuLBBgUKQ7/8eEi+1tz8YVd95BB3iY5oCLQPG7lALWJgGSOJxBRPc5BhQKymQPpsjEWTPf2884qFhuNu4IHcisJwzm2Imxb5sIBwIDAQAB";
        HttpGet get = new HttpGet("http://127.0.0.1/api/msgcenter/homepage/getMsgCount");
        String userid = Base64Utils.encodeToString(RSA.encrypt("1", spk));
        // token有效时间为: 1800s 也就是半个小时
        String token = "15889418-7830-4669-996c-3a87f9f48be1";

        get.setHeader("appid", APP_ID);
        get.setHeader("token", token);
        get.setHeader("userid", userid);
        CloseableHttpClient httpClient = HttpClients.createDefault();
        CloseableHttpResponse resp = httpClient.execute(get);
        logger.info("单独使用token调用接口, 返回值为: {}", EntityUtils.toString(resp.getEntity()));
    }

    public static void main(String[] args) throws IOException {
        // 向ECOLOGY系统注册许可证
        HttpPost post = new HttpPost("http://127.0.0.1/api/ec/dev/auth/regist");
        post.setHeader("appid", APP_ID);
        String cpk = RSA.getPublicKey();
        post.setHeader("cpk", cpk);
        CloseableHttpClient httpClient = HttpClients.createDefault();
        CloseableHttpResponse resp = httpClient.execute(post);
        org.apache.http.HttpEntity entity = resp.getEntity();
        JSONObject jsonObject = JSON.parseObject(EntityUtils.toString(entity));
        logger.info("向ecology系统注册许可证完毕! 返回值为: {}", jsonObject);


        // 获取Token
        HttpPost p2 = new HttpPost("http://127.0.0.1/api/ec/dev/auth/applytoken");
        // ECOLOGY返回的系统公钥
        String spk = jsonObject.getString("spk");
        // 对秘钥进行加密传输，防止篡改数据
        String secret = jsonObject.getString("secrit");
        String secretStr = Base64Utils.encodeToString(RSA.encrypt(secret, spk));
        p2.setHeader("appid", APP_ID);
        p2.setHeader("secret", secretStr);
        resp = httpClient.execute(p2);

        jsonObject = JSON.parseObject(EntityUtils.toString(resp.getEntity()));

        logger.info("获取token完毕, 返回值为: {}", jsonObject);

        // 普通接口调用
        HttpGet get = new HttpGet("http://127.0.0.1/api/msgcenter/homepage/getMsgCount");
        String userid = Base64Utils.encodeToString(RSA.encrypt("1", spk));
        String token = jsonObject.getString("token");

        get.setHeader("appid", APP_ID);
        get.setHeader("token", token);
        get.setHeader("userid", userid);
        resp = httpClient.execute(get);
        logger.info("接口调用成功, 返回值为: {}", EntityUtils.toString(resp.getEntity()));
    }
}
```


## 5. API文档在线说明

**1、简要描述：向OA系统发送许可证信息进行注册认证**

- 许可证注册接口

**请求URL：**
- [http://ip:port/api/ec/dev/auth/regist](http://ip:port/api/ec/dev/auth/regist)

**请求方式：**
- POST

**请求头部参数：**

| 参数名 | 必选 | 类型   | 说明         |
| ------ | ---- | ------ | ------------ |
| appid  | 是   | string | 许可证号码   |
| cpk    | 是   | string | 异构系统公钥 |

**接口参数：无**

**返回示例**

```json
{
	"msg": "ok",
	"errcode": "0",
	"code": 0,
	"msgShowType": "none",
	"secrit": "e0ab4a73-e9c6-4ae5-9dac-f21a7807991a",
	"errmsg": "ok",
	"status": true,
	"spk":"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmNIfHNjAvtvkSKtAj79mkHOk5/bDwrGVykRJ7saI1oLHPp8lEQjBP5Ae4Te5chzflLLEj4WP24JnY2ahzb8xnPU/HNt/lwhykjoxVPoczdlXL4jcdMuvgitgCQdrqPgtpzrKNOoKbTz9vagMl0LbzGlSzGPF4PAlGDw+OrgOMsiWXyG1EsQWOW5zfwnnGfvnPZlpSKfDKT3m+9oPL/cWQv6FU1A1kHO4ADT+Np8Q2n33mMJC1Sc+YiFjNIblGoB0AME7M0hb+Ln4b+n+23jsBBeZhfBdmRdLY31AALWIuJH1+8KZvaaMS0OwkBdCfZhF4chWYSRAV4yjCx19Ax/wBQIDAQAB"
}
```

**返回参数说明**

| 参数名      | 类型    | 说明                                                         |
| ----------- | ------- | ------------------------------------------------------------ |
| status      | boolean | 响应状态。true:成功,false:失败                               |
| code        | String  | 响应码。0代表成功                                            |
| errcode     | String  | 错误码。0代表成功（可忽略）                                  |
| msg         | String  | 响应信息                                                     |
| msgShowType | String  | 信息显示类型 默认"none"                                      |
| secrit      | String  | 秘钥信息。注意此处secrit单词拼写错误（原词为：secret），请使用 secrit获取结果 |
| spk         | String  | 系统公钥信息                                                 |

**返回错误示例一**

```json
{
	"msg": "ok",
	"errcode": "1",
	"code": -1,
	"msgShowType": "none",
	"errmsg": "passowrd error:null & sysadmin",
	"status": false
}
```

**返回错误示例二**

```json
{
	"msg": "ok",
	"errcode": "1",
	"code": 0,
	"msgShowType": "none",
	"errmsg": "注册失败没有在找到正确的APPID:EEAA5436-7577-4BE0-8C6C-89E9D888",
	"status": false
}
```


**2、简要描述：向OA系统发送获取token请求**
- 获取token接口

**请求URL：**
- [http://ip:port/api/ec/dev/auth/applytoken](http://ip:port/api/ec/dev/auth/applytoken)

**请求方式：**
- POST

**请求头部参数：**

| 参数名 | 必选 | 类型   | 说明                                                         |
| ------ | ---- | ------ | ------------------------------------------------------------ |
| appid  | 是   | string | 许可证号码                                                   |
| secret | 是   | string | 注册许可证时返回的公钥spk对秘钥信息secrit进行加密。（注意此处参数名单词拼写正确） |

**返回示例**

```json
{
	"msg": "获取成功!",
	"code": 0,
	"msgShowType": "none",
	"status": true,
	"token": "770a10d8-0b15-492b-a614-b2c537b512e5"
}
```
**返回参数说明**

| 参数名      | 类型    | 说明                                      |
| ----------- | ------- | ----------------------------------------- |
| status      | boolean | 响应状态。true:成功,false:失败            |
| code        | String  | 响应码。0代表成功                         |
| msg         | String  | 响应信息                                  |
| msgShowType | String  | 信息显示类型 默认"none"                   |
| token       | String  | 认证通过的token信息。（默认30分钟内有效） |

**返回错误示例一**

```json
{
	"msg": "认证信息错误！",
	"code": -1,
	"msgShowType": "none",
	"status": false
}
```
**返回错误示例二**

```json
{
	"msg": "解密失败！",
	"code": -1,
	"msgShowType": "none",
	"status": false
}
```


**3、简要描述：通过token的方式认证调用ECOLOGY系统普通接口**
- token使用演示接口,该API没有实际意义

**请求URL：**
- [http://ip:port/api/接口地址](http://ip:port/api/接口地址)

**请求方式：**
- `GET` | `POST` | `PUT` | `DELETE`

**请求头部参数：**

| 参数名 | 必选 | 类型   | 说明                                                |
| ------ | ---- | ------ | --------------------------------------------------- |
| appid  | 是   | string | 许可证号码                                          |
| userid | 是   | string | 通过注册许可时返回spk公钥对userid进行加密生成的密文 |
| appid  | 是   | string | 许可证号码                                          |

**接口返回值:** 以实际调用的接口为准!