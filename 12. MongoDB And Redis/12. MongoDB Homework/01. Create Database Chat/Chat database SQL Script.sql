mongo
use chat
db.createCollection('messages')
db.createCollection('users')
db.users.insert({username: 'pesho', fullname: 'Petar Petrov'})
db.users.insert({username: 'minka', fullname: 'Minka Svirchova'})
db.users.insert({username: 'ginka', fullname: 'Ivan Jelqzkov'})
db.users.insert({username: 'jelatinka', fullname: 'Aladeen Shamathamen'})

// Yes, I know I can extract the values with a query, I was just lazy to do it.
// Here is the syntax if you are wondering: db.users.find({username: '<your_user_name>'}, {_id: 1}), by the second object argument
 we specify that we want to see only the id field, which is TRUE by default so it is kind of explicit right there 

var peshoId = ObjectId("55a40bf94a1e0eeb17f24c70")
var minkaId = ObjectId("55a40e614a1e0eeb17f24c71")
var ginkaId = ObjectId("55a40e644a1e0eeb17f24c72")
var jelatinkaId = ObjectId("55a40e674a1e0eeb17f24c73")


db.messages.insert({userId: peshoId, text: 'Eeeeeeha, kak beshe izpita po bazi danni', date: new Date()})
db.messages.insert({userId: minkaId, text: 'Mnogo jega, pot i smrad', date: new Date()})
db.messages.insert({userId: peshoId, text: 'Nqkakuv do men reshi 2ra zadacha :OOOOOO', date: new Date()})
db.messages.insert({userId: ginkaId, text: 'A do men puk edin prucna :)', date: new Date()})
db.messages.insert({userId: jelatinkaId, text: 'Hahahahaha, vie dobre li ste, az vzeh 3 tochki!', date: new Date()})
db.messages.insert({userId: jelatinkaId, text: 'Allahu Akbar!', date: new Date()})