import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/sqlite/LessonDao.dart';
import 'package:sqlite_demo/sqlite/ScheduleDao.dart';
import 'package:sqlite_demo/sqlite/UserDao.dart';

class SqliteHelper {
  static const int _VERSION = 1;
  static const String _DB_NAME = "mydb";
  static Database? _db;

  Future<Database> getEmptyDb() async {
    await databaseFactory.deleteDatabase(_DB_NAME);
    await _initDb();
    return _db!;
  }

  Future<Database> getDb() async {
    bool needInit = await _initDb();
    if(needInit){
      await _addEzreal();
      await _addGragas();
      await _addLeeSin();
      await _addRyze();
      await _addSion();
      await _addYasuo();
      await _addStudent();
    }
    return _db!;
  }

  Future<bool> _initDb() async {
    bool needInit = false;
    _db ??= await openDatabase(_DB_NAME, version: _VERSION,
        onCreate: (db, version) async {
          debugPrint("sqlite create");
          await db.execute(UserDao.CREATE_TABLE);
          await db.execute(LessonDao.CREATE_TABLE);
          await db.execute(ScheduleDao.CREATE_TABLE);
          needInit = true;
        },
        onUpgrade: (db, oldVersion, newVersion){
          debugPrint("sqlite upgrade $oldVersion -> $newVersion");
        },
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        }
    );
    return needInit;
  }

  Future<void> closeDb() async {
    if(_db != null){
      await _db!.close();
      _db = null;
    }
  }

  Future<void> _addGragas() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Gragas",
        introduction: "古拉格斯是一名身形龐大，行為舉止豪邁粗魯的釀酒大師。他唯一的夢想就是釀造出一款完美的麥芽酒。沒有人知道古拉格斯來自哪裡，目前他人在弗雷爾卓德，積極地從沒有受到汙染的純淨之地找尋珍貴的原料，並嘗試他研發的每一個配方。古拉格斯的個性十分衝動，而且經常喝醉，他最為人所知的事蹟就是每次喝醉都會打架鬧事，最終以徹夜狂歡和他人的財產損失收場。基本上古拉格斯的行為模式一定是先喝醉，然後開始大搞破壞。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/0/02/Gragas_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20150402220132",
        account: "gragas",
        password: "123456",
        job: UserDao.ENUM_DEMONSTRATOR
    );
    await lessonDao.insert(
        title: "滾動酒桶",
        description: "古拉格斯將酒桶滾到目標地點，可以主動引爆或在到達目標地點 4 秒後自行爆炸。爆炸的威力會隨時間持續提升。被炸到的敵人跑速會降低。",
        teacher_id: teacher_id,
        time_json: ["108", "109"],
    );
    await lessonDao.insert(
        title: "醉酒狂暴",
        description: "古拉格斯狂飲酒桶裡的佳釀，持續 1 秒。完成後會獲得強化能力，對下次普攻目標和鄰近敵人造成魔法傷害，並減少所受的傷害。",
        teacher_id: teacher_id,
        time_json: ["110", "111"],
    );
    await lessonDao.insert(
        title: "肉彈衝擊",
        description: "古拉格斯向目標方向衝鋒，撞上第一個敵方單位後造成範圍傷害，並暈眩他們。",
        teacher_id: teacher_id,
        time_json: ["113", "114"],
    );
    await lessonDao.insert(
        title: "爆破酒桶",
        description: "古拉格斯向目標區域投擲他的酒桶，造成傷害並擊退在衝擊波範圍內敵人。",
        teacher_id: teacher_id,
        time_json: ["115", "116"],
    );
  }

  Future<void> _addEzreal() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Ezreal",
        introduction: "伊澤瑞爾是一名瀟灑帥氣的探險家，他憑藉著偶然得到的魔法祕寶洗劫失落已久的墓穴，並輕鬆擺脫那些古老的詛咒。膽量過人的他熱愛挑戰看似不可能脫逃的險境，雖然一部分可以歸功於他的機智，但他主要還是仰賴他手上那個來自古蘇瑞瑪的魔法臂鎧。這個臂鎧讓伊澤瑞爾可以憑空發射出毀滅性的祕術能量。每次見到伊澤瑞爾的時候都可以確定一件事：那就是麻煩即將找上門。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/5/54/Ezreal_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20150402220010",
        account: "ezreal",
        password: "123456",
        job: UserDao.ENUM_SENIOR_LECTURER
    );
    await lessonDao.insert(
        title: "祕術射擊",
        description: "伊澤瑞爾發射一枚能量彈，成功命中一名敵方單位時所有技能都將縮短些許冷卻時間。",
        teacher_id: teacher_id,
        time_json: ["208", "209"],
    );
    await lessonDao.insert(
        title: "精華躍動",
        description: "伊澤瑞爾發射一顆能量球，其會附著在首位擊中的敵方英雄或地圖物件。若伊澤瑞爾攻擊被能量球附著的單位，能量球將引爆並對該目標造成傷害。",
        teacher_id: teacher_id,
        time_json: ["210", "211"],
    );
    await lessonDao.insert(
        title: "奧術躍遷",
        description: "伊澤瑞爾傳送至鄰近區域並向最近的敵方單位發射魔法箭。會優先鎖定身上有精華躍動印記的單位。",
        teacher_id: teacher_id,
        time_json: ["213", "214"],
    );
    await lessonDao.insert(
        title: "精準彈幕",
        description: "伊澤瑞爾吟唱後發射強大的能量波，對路徑上的敵方單位造成大量傷害 (對士兵和非史詩級野怪造成的傷害減少)。",
        teacher_id: teacher_id,
        time_json: ["215", "216"],
    );
  }

  Future<void> _addLeeSin() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Lee Sin",
        introduction: "李星是精通愛歐尼亞古代武術的大師，也是秉持著操守的鬥士，每當眼前出現挑戰，他體內蘊藏的龍魂之力就會發揮作用，帶給他超凡的力量。雖然許多年前他失去了視力，但這名武僧卻依舊致力於保護他的家鄉，消滅任何膽敢破壞愛歐尼亞神聖平衡的惡徒。見他時常沉靜冥思便低估他的人，最後不是被他的拳頭擊倒，就是慘死於他的迴旋踢之下。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/1/16/Lee_Sin_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20240418183049",
        account: "leesin",
        password: "123456",
        job: UserDao.ENUM_LECTURER
    );
    await lessonDao.insert(
        title: "虎嘯龍吟 ／ 震驚百里",
        description: "虎嘯龍吟：李星發出梵音尋找敵人，對被音波擊中的首位敵人造成物理傷害。如果虎嘯龍吟擊中敵人，李星可以在接下來 3 秒內使出震驚百里。 震驚百里：李星衝向被梵音擊中的敵人，根據目標已損失的生命造成物理傷害。",
        teacher_id: teacher_id,
        time_json: ["308", "309"],
    );
    await lessonDao.insert(
        title: "鐵璧金身 ／ 易筋洗髓",
        description: "鐵璧金身：李星衝向一名目標友方單位，在自己身上附加護盾。若目標為英雄，對方也會獲得護盾。使用「鐵璧金身」後，李星便可使出「易筋洗髓」。 易筋洗髓：李星接受過嚴格的肉體訓練，使他在戰鬥中更為強健。李星獲得普攻吸血及技能吸血。",
        teacher_id: teacher_id,
        time_json: ["310", "311"],
    );
    await lessonDao.insert(
        title: "狂風暴雨 ／ 分筋錯骨",
        description: "狂風暴雨：李星重擊地面，放出衝擊波，對命中的敵軍造成魔法傷害，並揭露其位置。如果「狂風暴雨」命中敵軍，李星便可施展「分筋錯骨」。 分筋錯骨：李星對受到「狂風暴雨」攻擊的周圍敵人施展分筋錯骨，降低其跑速。跑速會在持續時間內逐漸回復。",
        teacher_id: teacher_id,
        time_json: ["313", "314"],
    );
    await lessonDao.insert(
        title: "神龍擺尾",
        description: "李星使用強力迴旋踢把目標往後踢，對目標造成物理傷害，同時所有被撞擊到的敵方單位會在短時間內被撞擊至空中。這招是由英雄聯盟的傳奇武聖 Jesse Perring 親授，不過李星的火候不足，無法把對手踢出地圖。",
        teacher_id: teacher_id,
        time_json: ["315", "316"],
    );
  }

  Future<void> _addYasuo() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Yasuo",
        introduction: "犽宿是一名擁有鋼鐵意志的愛歐尼亞人，亦是個行動快如疾風、可以舞動清風來斬斷敵人的劍士。只不過年輕驕傲的他，被誤認為謀殺師傅的兇手——在無法證明自己清白的情況下，為了自衛而失手殺了自己的兄長。即使在師傅的命案真相大白後，犽宿仍舊無法原諒自己所做的一切，現在他不斷地在家鄉流浪，伴隨在他的刀刃左右的唯有一股疾風。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/a/ad/Yasuo_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20150402222545",
        account: "yasuo",
        password: "123456",
        job: UserDao.ENUM_PROFESSOR
    );
    await lessonDao.insert(
        title: "鋼鐵暴雪",
        description: "向前突刺，傷害前方直線上的所有敵人。 命中敵人後，獲得一層天寒地凍累加效果，持續數秒。達 2 層時，鋼鐵暴雪會擊出一道旋風，並對命中的敵人造成滯空。 鋼鐵暴雪被視為普攻的一種，效果機制全部跟普攻一樣。",
        teacher_id: teacher_id,
        time_json: ["408", "409"],
    );
    await lessonDao.insert(
        title: "風牆鐵壁",
        description: "製造一道移動牆面阻擋所有敵方火力，持續 4 秒。",
        teacher_id: teacher_id,
        time_json: ["410", "411"],
    );
    await lessonDao.insert(
        title: "刃敵千軍",
        description: "朝目標敵人衝刺，造成魔法傷害。每次施放都會增加下次衝刺的傷害，直到達到傷害值上限。 數秒內無法重複施放在同一個目標上。 如果在衝刺期間施放鋼鐵暴雪，其將以圓圈的形式揮砍，攻擊犽宿身邊的敵人。",
        teacher_id: teacher_id,
        time_json: ["413", "414"],
    );
    await lessonDao.insert(
        title: "奪命氣息",
        description: "瞬間移動至滯空的敵方英雄身邊，延長所有目標的滯空時間。風湧回滿但重置鋼鐵暴雪的堆層。 之後一段時間內，犽宿的暴擊獲得顯著的額外物理穿透效果。",
        teacher_id: teacher_id,
        time_json: ["415", "416"],
    );
  }

  Future<void> _addSion() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Sion",
        introduction: "過去的戰爭英雄賽恩，因為赤手扼殺了蒂瑪西亞的國王而受到諾克薩斯全國上下的崇敬——但他死後仍不得安寧，被復活來再度為自己的帝國效勞。無論是敵是友，賽恩都不分青紅皂白地屠殺眼前的人們，證實了自己已經不再保有生前的人性。賽恩腐爛的肉體上披著粗糙的盔甲，他仍繼續肆無忌憚地衝上戰場。在每次揮動巨斧之間，他拼命嘗試回想自己原本的模樣，但怎麼想都想不起來。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/e/ea/Sion_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20150402221054",
        account: "sion",
        password: "123456",
        job: UserDao.ENUM_PROFESSOR
    );
    await lessonDao.insert(
        title: "巨幅毀滅",
        description: "賽恩在自己前方的區域揮動武器對敵人造成傷害，如果他蓄力夠久，被命中的敵人將會被暈眩並且擊飛。",
        teacher_id: teacher_id,
        time_json: ["508", "509"],
    );
    await lessonDao.insert(
        title: "魂魄熔爐",
        description: "賽恩使用護盾保護自己，並且可以在 3 秒後重新引爆護盾對周圍的敵人造成魔法傷害。當賽恩擊殺敵軍，提升最大生命。",
        teacher_id: teacher_id,
        time_json: ["510", "511"],
    );
    await lessonDao.insert(
        title: "殺戮怒吼",
        description: "賽恩發射一個短程衝擊波對第一個命中的敵人造成傷害，緩速該名敵人並且減少其物理防禦。如果衝擊波命中了士兵或是野怪，目標將會被擊退，而所有被賽恩擊退的目標打到的敵人，將會被緩速、受到傷害、及減少物理防禦效果。",
        teacher_id: teacher_id,
        time_json: ["513", "514"],
    );
    await lessonDao.insert(
        title: "猛烈狂擊",
        description: "賽恩往一個固定方向衝刺，隨時間加速。可以藉由滑鼠游標來操縱衝刺方向。當他撞擊敵人時將會造成傷害並且根據自己衝刺的距離來擊飛目標。",
        teacher_id: teacher_id,
        time_json: ["515", "516"],
    );
  }

  Future<void> _addRyze() async {
    final userDao = UserDao();
    final lessonDao = LessonDao();
    final teacher_id = await userDao.insert(
        name: "Ryze",
        introduction: "古老而頑強的大法師雷茲，是符文大地公認經驗最豐富的法師之一，然而他也肩負著常人難以想像的重擔。他身懷強大的奧術之力，背後的魔法卷軸收錄了各種神祕法術。他不辭辛勞四處搜尋世界符文──蘊含原始魔法的碎片，這股力量曾被用來從虛無之中塑造了世界。他必須盡快找回這些符文，以免它們落入惡人之手，因為雷茲深知這些符文可能對符文大地造成的嚴重危害。",
        avatar: "https://static.wikia.nocookie.net/leagueoflegends/images/2/23/Ryze_OriginalSquare.png/revision/latest/scale-to-width-down/46?cb=20160630224634",
        account: "ryze",
        password: "123456",
        job: UserDao.ENUM_PROFESSOR
    );
    await lessonDao.insert(
        title: "超負荷",
        description: "被動：雷茲的其它基礎技能會重置【超負荷】的冷卻時間並且充能一層符文。當雷茲在有著 2 層符文的狀態下施放【超負荷】時，他會獲得短暫的爆發性跑速加成。 施放時，雷茲會沿直線扔出一道純粹的能量，對命中的第一個敵人造成傷害。如果目標身上有【法術湧動】效果，那麼【超負荷】會造成額外傷害並彈射至附近帶有【法術湧動】效果的敵人身上。",
        teacher_id: teacher_id,
        time_json: ["608", "609"],
    );
    await lessonDao.insert(
        title: "符文禁錮",
        description: "雷茲使用符文將敵人禁錮，傷害並緩速他們。如果目標身上帶有【法術湧動】效果，那麼緩速效果會替換為定身效果。",
        teacher_id: teacher_id,
        time_json: ["610", "611"],
    );
    await lessonDao.insert(
        title: "法術湧動",
        description: "雷茲釋放一顆精純魔法能量匯聚的光球，傷害一名敵人並對所有附近的敵人造成減益效果。雷茲的技能可以對帶有該減益效果的敵人造成額外效果。",
        teacher_id: teacher_id,
        time_json: ["613", "614"],
    );
    await lessonDao.insert(
        title: "扭轉之境",
        description: "被動：【超負荷】對帶有【法術湧動】效果的目標造成更多傷害。 施放時，雷茲會創造一個傳送門來通往一個附近的位置。在數秒後，站在傳送門附近的友軍會被傳送至目標位置。",
        teacher_id: teacher_id,
        time_json: ["615", "616"],
    );
  }

  Future<void> _addStudent() async {
    final userDao = UserDao();
    await userDao.insert(
        name: "Jyun Yi (襯衫)",
        introduction: "襯衫俊毅",
        avatar: "https://scontent.ftpe14-1.fna.fbcdn.net/v/t39.30808-6/360160780_6368772023210857_1282950499820586998_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=Y0KUroc9wz4Q7kNvgEgg53F&_nc_ht=scontent.ftpe14-1.fna&oh=00_AYDIHHvsdj4nABT_tSCG-q472YxbCyMsgbrB7WtEfB8_jg&oe=66436856",
        account: "jyunyi_a",
        password: "123456",
        job: UserDao.ENUM_STUDENT
    );
    await userDao.insert(
        name: "Jyun Yi (西裝)",
        introduction: "西裝俊毅",
        avatar: "https://scontent.ftpe14-1.fna.fbcdn.net/v/t31.18172-8/18076652_1338229222931854_2194295015603404850_o.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_ohc=gK_bDlgPiRAQ7kNvgGfMuEZ&_nc_ht=scontent.ftpe14-1.fna&oh=00_AYC4TCHJwGlFYUSh_aROCL53NmNSInBug3G8fmbN1vM_mQ&oe=6665AAD4",
        account: "jyunyi_b",
        password: "123456",
        job: UserDao.ENUM_STUDENT
    );
    await userDao.insert(
        name: "Jyun Yi (T恤)",
        introduction: "T恤俊毅",
        avatar: "https://scontent.ftpe14-1.fna.fbcdn.net/v/t1.18169-9/10626703_717432198344896_7096180867927886158_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_ohc=FQp1AE-ZnacQ7kNvgHPvQCm&_nc_ht=scontent.ftpe14-1.fna&oh=00_AYAIZzI_WHIJRJxyq8jGtBEn5MlEOIxgSmslCpV2K15G6A&oe=6665AD71",
        account: "jyunyi_c",
        password: "123456",
        job: UserDao.ENUM_STUDENT
    );
  }
}