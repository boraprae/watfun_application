require('dotenv').config();
const express = require('express');
// const jwt = require('jsonwebtoken');
const path = require('path');
const app = express();

// static folders
app.use('/public', express.static(path.join(__dirname, "/public")));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//---- mysql -----
const mysql = require("mysql");
const config = require("./dbConfig.js");
const con = mysql.createConnection(config);

// ============= Dummy data ================
const user = [
    { 'user_id': 1, 'user_username': 'admin', 'user_password': '1111', 'user_role': 1 },
    { 'user_id': 2, 'user_username': 'user2', 'user_password': '2222', 'user_role': 2 },
    { 'user_id': 3, 'user_username': 'user3', 'user_password': '3333', 'user_role': 2 },
]

const data = [
    { 'id': 1, 'title': 'First', 'detail': 'aaa', 'user_id': 2 },
    { 'id': 2, 'title': 'Second', 'detail': 'bbb', 'user_id': 2 },
    { 'id': 3, 'title': 'Third', 'detail': 'ccc', 'user_id': 3 },
    { 'id': 4, 'title': 'Fourth', 'detail': 'ddd', 'user_id': 3 },
]

// // ==================== Middleware ==============
// function checkUser(req, res, next) {
//     let token = req.headers['authorization'] || req.headers['x-access-token'];
//     if (token == undefined || token == null) {
//         // no token
//         res.status(400).send('No token');
//     }
//     else {
//         // token found
//         if (req.headers.authorization) {
//             const tokenString = token.split(' ');
//             if (tokenString[0] == 'Bearer') {
//                 token = tokenString[1];
//             }
//         }
//         jwt.verify(token, process.env.JWT_KEY, (err, decoded) => {
//             if (err) {
//                 res.status(400).send('Incorrect token');
//             }
//             else {
//                 req.decoded = decoded;
//                 // back to the service
//                 next();
//             }
//         });
//     }
// }

// // ------------- Routes ---------------------
// // ************* Page routes **************
// app.get('/', (req, res) => {
//     const message = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
//     res.render('index', { message: message });
// });

// app.get('/blogs', (_req, res) => {
//     const data = [
//         { 'id': 1, 'title': 'First', 'detail': 'aaa' },
//         { 'id': 2, 'title': 'Second', 'detail': 'bbb' },
//         { 'id': 3, 'title': 'Third', 'detail': 'ccc' },
//     ];
//     res.render('blog', { post: data });
// });

// // ************* Authen routes **************
// app.post('/login', (req, res) => {
//     setTimeout(() => {
//         const { username, password } = req.body;
//         const result = user.filter((value) => {
//             return value.user_username == username && value.user_password == password;
//         });
//         // res.json(result);

//         if (result.length == 1) {
//             const payload = { user: username, user_id: result[0].user_id };
//             const token = jwt.sign(payload, process.env.JWT_KEY, { expiresIn: '1d' });
//             res.json({ url: '/blogs', token: token });
//             // res.send('/blogs');
//         }
//         else {
//             res.status(400).send('Wrong username or password');
//         }
//     }, 3000);
// });

// // jwt creation / encode
// app.get('/jwt', (_req, res) => {
//     const username = 'admin';
//     const payload = { user: username };
//     const token = jwt.sign(payload, process.env.JWT_KEY, { expiresIn: '1d' });
//     res.send(token);
// });

// // jwt decode
// app.post('/jwtDecode', (req, res) => {
//     // const token = req.body.token;
//     // const token = req.headers['x-access-token'];
//     // const token = req.headers['authorization'];
//     let token = req.headers['authorization'] || req.headers['x-access-token'];
//     if (token == undefined || token == null) {
//         // no token
//         res.status(400).send('No token');
//     }
//     else {
//         // token found
//         if (req.headers.authorization) {
//             const tokenString = token.split(' ');
//             if (tokenString[0] == 'Bearer') {
//                 token = tokenString[1];
//             }
//         }
//         jwt.verify(token, process.env.JWT_KEY, (err, decoded) => {
//             if (err) {
//                 res.status(400).send('Incorrect token');
//             }
//             else {
//                 res.send(decoded);
//             }
//         });
//     }
// });

// app.delete('/post', (req, res) => {
//     let token = req.headers['authorization'] || req.headers['x-access-token'];
//     if (token == undefined || token == null) {
//         // no token
//         res.status(400).send('No token');
//     }
//     else {
//         // token found
//         if (req.headers.authorization) {
//             const tokenString = token.split(' ');
//             if (tokenString[0] == 'Bearer') {
//                 token = tokenString[1];
//             }
//         }
//         jwt.verify(token, process.env.JWT_KEY, (err, decoded) => {
//             if (err) {
//                 res.status(400).send('Incorrect token');
//             }
//             else {
//                 // delete the post in DB....
//                 res.send('Deleted. Thanks ' + decoded.user);
//             }
//         });
//     }
// });

// // ----------- Mobile routes ------------
// app.get('/mobile/blogs', checkUser, (req, res) => {
//     // get userID from token
//     const result = req.decoded;
//     const userID = result.user_id;
//     // filter blog posts for this user
//     const posts = data.filter((value) => {
//         return value.user_id == userID;
//     });
//     res.json(posts);
// });

// ---------- Sever starts here ---------
const PORT = 6000;
app.listen(PORT, () => {
    console.log('Server is running at ' + PORT);
});