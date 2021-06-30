drop table user if exists;

create table user
(
    id   INTEGER GENERATED BY DEFAULT AS IDENTITY (START WITH 1) PRIMARY KEY,
    name VARCHAR(32) DEFAULT 'DEFAULT',
    sex  VARCHAR(2)
);

insert into user(id, name, sex)
values (1, '张无忌', '男'),
       (2, '赵敏', '女'),
       (3, '周芷若', '女'),
       (4, '小昭', '女'),
       (5, '殷离', '女'),
       (6, '张翠山', '男'),
       (7, '殷素素', '女'),
       (8, '金毛狮王', '男'),
       (9, '张三丰', '男'),
       (10, '宋远桥', '男'),
       (11, '俞莲舟', '男'),
       (12, '俞岱岩', '男'),
       (13, '张松溪', '男'),
       (14, '殷梨亭', '男'),
       (15, '莫声谷', '男'),
       (16, '纪晓芙', '女'),
       (17, '成昆', '男'),
       (18, '杨逍', '男'),
       (19, '范遥', '男'),
       (20, '殷天正', '男'),
       (21, '殷野王', '男'),
       (22, '黛绮丝', '女'),
       (23, '灭绝师太', '女'),
       (24, '韦一笑', '男'),
       (25, '周颠', '男'),
       (26, '说不得', '男'),
       (27, '谦卑', '男'),
       (28, '彭莹玉', '男'),
       (29, '常遇春', '男'),
       (30, '胡青牛', '男'),
       (31, '王难姑', '女'),
       (32, '朱元璋', '男'),
       (33, '杨不悔', '女'),
       (34, '鹿杖客', '男'),
       (35, '鹤笔翁', '男'),
       (36, '丁敏君', '女'),
       (37, '宋青书', '男'),
       (38, '何太冲', '男'),
       (39, '朱长龄', '男'),
       (40, '朱九真', '女'),
       (41, '武青婴', '女'),
       (42, '卫璧', '男'),
       (43, '汝阳王', '男'),
       (44, '王保保', '男'),
       (45, '觉远', '男'),
       (46, '郭襄', '女'),
       (47, '张君宝', '男'),
       (48, '何足道', '男'),
       (49, '都大锦', '男'),
       (50, '韩姬', '女'),
       (51, '黄衫女子', '女'),
       (52, '陈友谅', '男'),
       (53, '韩千叶', '男');

-- 联合主键
create table user_ids
(
    id1  INTEGER,
    id2  INTEGER,
    name VARCHAR(32) DEFAULT 'DEFAULT',
    PRIMARY KEY (id1, id2)
);

insert into user_ids(id1, id2, name)
values (1, 1, '张无忌1'),
       (1, 2, '张无忌2'),
       (1, 3, '张无忌3'),
       (1, 4, '张无忌4');