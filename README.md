![logo](logo.png)
# MyBatis Mapper


基于 **mybatis-mapper/provider**( [gitee](https://gitee.com/mybatis-mapper/provider)
| [GitHub](https://github.com/mybatis-mapper/provider) ) 实现的通用 Mapper。

## 1. 快速入门

这是一个不需要任何配置就可以直接使用的通用 Mapper，通过简单的学习就可以直接在项目中使用。

### 1.1 本项目的主要目标

1. 开箱即用，无需任何配置，继承基类 Mapper 即可获得大量通用方法；
2. 随心所欲，通过复制粘贴的方式可以组建自己的基类 Mapper；
3. 全面贴心，提供 Service 层的封装方便业务使用和理解 Mapper；
4. 简单直观，提供 ActiveRecord 模式，结合 Spring Boot 自动配置直接上手用。

### 1.2 系统要求

MyBatis Mapper 要求 MyBatis 最低版本为
3.5.1，推荐使用最新版本 [![Maven central](https://maven-badges.herokuapp.com/maven-central/org.mybatis/mybatis/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.mybatis/mybatis) 。

和 MyBatis 框架一样，最低需要 Java 8。

### 1.3 安装

如果你使用 Maven，在你的 `pom.xml` 添加下面的依赖：

```xml
<dependencies>
  <dependency>
    <groupId>io.mybatis</groupId>
    <artifactId>mybatis-mapper</artifactId>
    <version>1.0.0-SNAPSHOT</version>
  </dependency>
  <!-- 使用 Service 层封装时 -->
  <dependency>
    <groupId>io.mybatis</groupId>
    <artifactId>mybatis-service</artifactId>
    <version>1.0.0-SNAPSHOT</version>
  </dependency>
  <!-- 使用 ActiveRecord 模式时 -->
  <dependency>
    <groupId>io.mybatis</groupId>
    <artifactId>mybatis-activerecord</artifactId>
    <version>1.0.0-SNAPSHOT</version>
  </dependency>
</dependencies>
```

如果使用 Gradle，在 `build.gradle` 中添加：

```groovy
dependencies {
  compile("io.mybatis:mybatis-mapper:1.0.0-SNAPSHOT")
  // 使用 Service 层封装时
  compile("io.mybatis:mybatis-service:1.0.0-SNAPSHOT")
  // 使用 ActiveRecord 模式时
  compile("io.mybatis:mybatis-activerecord:1.0.0-SNAPSHOT")
}
```

### 1.4 快速设置

MyBatis Mapper 的基本原理是将实体类映射为数据库中的表和字段信息，因此实体类需要通过注解配置基本的元数据，配置好实体后，
只需要创建一个继承基础接口的 Mapper 接口就可以开始使用了。

#### 1.4.1 实体类配置

假设有一个表：
```sql
create table user
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    name VARCHAR(32) DEFAULT 'DEFAULT',
    sex  VARCHAR(2)
);
```
对应的实体类：
```java
import io.mybatis.provider.Entity;

@Entity.Table("user")
public class User {
  @Entity.Column(id = true)
  private Long   id;
  @Entity.Column("name")
  private String username;
  @Entity.Column
  private String sex;

  //省略set和get方法
}
```

实体类上 **必须添加** `@Entity.Table` 注解指定实体类对应的表名，建议明确指定表名，不提供表名的时候，使用类名作为表名。
所有属于表中列的字段，**必须添加** `@Entity.Column` 注解，不指定列名时，使用字段名（不做任何转换），通过 `id=true` 可以标记字段为主键。

>`@Entity` 中包含的这两个注解提供了大量的配置属性，想要使用更多的配置，参考下面 **3. @Entity 注解** 的内容，
>下面是一个简单示例：
>```java
>@Entity.Table(value = "sys_user", remark = "系统用户", autoResultMap = true)
>public class User {
>  @Entity.Column(id = true, remark = "主键", updatable = false, insertable = false)
>  private Long   id;
>  @Entity.Column(value = "name", remark = "帐号")
>  private String userName;
>  //省略其他
>}
>```

#### 1.4.2 Mapper接口定义

有了 `User` 实体后，直接创建一个继承了 `Mapper` 的接口即可：
```java
public interface UserMapper extends Mapper<User, Long> {
  
}
```
这个接口只要被 MyBatis 扫描到即可直接使用。

> 下面是几种常见的扫描配置：
> 
> 1. MyBatis 自带的配置文件方式 `mybatis-config.xml`：
> ```xml
>  <mappers>
>    <!-- 扫描指定的包 -->
>    <package name="com.example.mapper"/>
>  </mappers>
> ```
> 
> 2. Spring 中的 `spring.xml` 配置：
> ```xml
> <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
>   <property name="basePackage" value="com.example.mapper"/>
>   <property name="markerInterface" value="io.mybatis.service.mapper.RoleMarker"/>
>   <property name="sqlSessionFactoryBeanName" value="sqlSessionFactoryRole"/>
> </bean>
> ```
> 
> 3. Spring Boot 配置，启动类注解方式：
> ```java
> @MapperScan(basePackages = "com.example.mapper")
> @SpringBootApplication
> public class SpringBootDemoApplication {
> 
>   public static void main(String[] args) {
>     SpringApplication.run(SpringBootDemoApplication.class, args);
>   }
> 
> }
> ```
> Spring Boot 中，还可以直接给接口添加 `@org.apache.ibatis.annotations.Mapper` 注解，增加注解后可以省略 `@MapperScan` 配置。

#### 1.4.3 使用

定义好接口后，就可以获取 `UserMapper` 使用，下面是简单示例：
```java
User user = new User();
user.setUserName("测试");
userMapper.insert(user);
//保存后自增id回写，不为空
Assert.assertNotNull(user.getId());
//根据id查询
user = userMapper.selectByPrimaryKey(user.getId());
//删除
Assert.assertEquals(1, userMapper.deleteByPrimaryKey(user.getId()));
```

看到这里，可以发现除了 MyBatis 自身的配置外，MyBatis Mapper 只需要配置实体类注解，
创建对应的 Mapper 接口就可以直接使用，没有任何繁琐的配置。

上面的示例只是简单的使用了 MyBatis Mapper，还有很多开箱即用的功能没有涉及，
建议在上述示例运行成功后，继续查看本项目其他模块的详细文档，熟悉各部分文档后，
在使用 MyBatis Mapper 时会更得心应手，随心所欲。

## 2. mapper 模块

基于 **mybatis-mapper/provider** 核心部分实现的基础的增删改查操作，提供了一个核心的 `io.mybatis.mapper.Mapper` 接口，接口定义如下：

```java
/**
 * 基础 Mapper 方法，可以在此基础上继承覆盖已有方法
 *
 * @param <T> 实体类类型
 * @param <I> 主键类型
 * @author liuzh
 */
public interface Mapper<T, I extends Serializable>
    extends EntityMapper<T, I>, ExampleMapper<T, Example<T>>, CursorMapper<T, Example<T>> {

  /**
   * 保存实体，默认主键自增，并且名称为 id
   * <p>
   * 这个方法是个示例，你可以在自己的接口中使用相同的方式覆盖父接口中的配置
   *
   * @param entity 实体类
   * @return 1成功，0失败
   */
  @Override
  @Lang(Caching.class)
  @Options(useGeneratedKeys = true, keyProperty = "id")
  @InsertProvider(type = EntityProvider.class, method = "insert")
  int insert(T entity);

  /**
   * 保存实体中不为空的字段，默认主键自增，并且名称为 id
   * <p>
   * 这个方法是个示例，你可以在自己的接口中使用相同的方式覆盖父接口中的配置
   *
   * @param entity 实体类
   * @return 1成功，0失败
   */
  @Override
  @Lang(Caching.class)
  @Options(useGeneratedKeys = true, keyProperty = "id")
  @InsertProvider(type = EntityProvider.class, method = "insertSelective")
  int insertSelective(T entity);

  /**
   * 根据主键更新实体中不为空的字段，强制字段不区分是否 null，都更新
   * <p>
   * 当前方法来自 {@link io.mybatis.mapper.fn.FnMapper}，该接口中的其他方法用 {@link ExampleMapper} 也能实现
   *
   * @param entity            实体类
   * @param forceUpdateFields 强制更新的字段，不区分字段是否为 null，通过 {@link Fn#of(Fn...)} 创建 {@link Fn.Fns}
   * @return 1成功，0失败
   */
  @Lang(Caching.class)
  @UpdateProvider(type = FnProvider.class, method = "updateByPrimaryKeySelectiveWithForceFields")
  int updateByPrimaryKeySelectiveWithForceFields(@Param("entity") T entity, @Param("fns") Fn.Fns<T> forceUpdateFields);

  /**
   * 根据指定字段集合查询：field in (fieldValueList)
   * <p>
   * 这个方法是个示例，你也可以使用 Java8 的默认方法实现一些通用方法
   *
   * @param field          字段
   * @param fieldValueList 字段值集合
   * @param <F>            字段类型
   * @return 实体列表
   */
  default <F> List<T> selectByFieldList(Fn<T, F> field, List<F> fieldValueList) {
    Example<T> example = new Example<>();
    example.createCriteria().andIn((Fn<T, Object>) field, fieldValueList);
    return selectByExample(example);
  }

  /**
   * 根据指定字段集合删除：field in (fieldValueList)
   * <p>
   * 这个方法是个示例，你也可以使用 Java8 的默认方法实现一些通用方法
   *
   * @param field          字段
   * @param fieldValueList 字段值集合
   * @param <F>            字段类型
   * @return 实体列表
   */
  default <F> int deleteByFieldList(Fn<T, F> field, List<F> fieldValueList) {
    Example<T> example = new Example<>();
    example.createCriteria().andIn((Fn<T, Object>) field, fieldValueList);
    return deleteByExample(example);
  }

}
```

这个接口展示了好几个通用方法的特点：

1. 可以继承其他通用接口
2. 可以重写继承接口的定义
3. 可以直接复制其他接口中的通用方法定义
4. 可以使用 Java8 默认方法灵活实现通用方法

在下面内容中，还能看到一个特点，“5. 那就是一个 provider 实现，通过修改接口方法的返回值和入参，就能变身无数个通用方法”，通用方法的实现极其容易。

点击[查看详细介绍](./mapper/README.md)。

## 3. @Entity 注解

这部分属于 **mybatis-mapper/provider** 核心部分提供的基础注解，可以直接配合 mapper 使用。

点击[查看详细介绍](./Entity.md)。

## 4. common 模块

当前模块包含了简单的封装代码，这部分的代码在 service 和 activerecord 中被用到，
如果不使用这两个包的功能，也不需要 common 模块的代码。

点击[查看详细介绍](./common/README.md)。

## 5. service 模块

service 模块对应开发中的 service 层，或者说是 Spring 中的 `@Service` 标记的类。

这一层基于 mapper 模块中的 `Mapper` 接口，封装了大量开箱即用的 service 层方法。

点击[查看详细介绍](./service/README.md)。

## 6. activerecord 模块

>**[Active Record](https://zh.wikipedia.org/wiki/Active_Record)** 模式
>
>在软件工程中，主动记录模式（active record pattern）是一种架构模式，
> 可见于在关系数据库中存储内存中对象的软件中。
> 它在Martin Fowler的2003年著《企业应用架构的模式》书中命名。
> 符合这个模式的对象的接口将包括函数比如插入、更新和删除，
> 加上直接对应于在底层数据库表格中列的或多或少的属性。
>
>主动记录模式是访问在数据库中的数据的一种方式。数据库表或视图被包装入类。
> 因此，对象实例被链接到这个表格的一个单一行。
> 在一个对象创建之后，在保存时将一个新行增加到表格中。
> 加载的任何对象都从数据库得到它的信息。在一个对象被更新的时候，
> 在表格中对应的行也被更新。包装类为在表格或视图中的每个列都实现访问器方法或属性。

activerecord 模块提供了 4 个接口类、1个工具类、1个配置类和1个Spring Boot自动配置类。

点击[查看详细介绍](./activerecord/README.md)。

## 7. generator 模块

本项目直接使用了一个功能强大的代码生成器 `睿Rui`，这个代码生成器可以设置项目的目录结构和具体的代码模板，
可以方便的从零生成一个完整的项目，也可以在已有项目结构中生成指定的代码文件。

点击[查看详细介绍](./generator/README.md)。
