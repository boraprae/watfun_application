//---------- import -----------
const express = require("express");
// const bcrypt = require('bcrypt');
const app = express();
const path = require("path");
const upload = require('./uploadConfig.js');

const bcrypt = require("bcrypt");

//---- mysql -----
const mysql = require("mysql");
const config = require("./dbConfig.js");
const e = require("express");
const { database, password } = require("./dbConfig.js");
const con = mysql.createConnection(config);

//middleware is .use
app.use(express.static(path.join(__dirname, "public"))) //สามารถเข้าถึงได้อย่างอิสระทำให้ไม่จำเป็นต้องระบุโฟลเดอร์หน้าไฟล์ script ถ้าใช้ cdn ไม่จำเป็นต้องใช้ก็ได้
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ****** Page Routes ******
// ----- root service -----
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "public/upload.html"))
});
// app.get("/admin", (req, res) => {
//     res.sendFile(path.join(__dirname, "/admin.html"))
// });
app.get("/login", (req, res) => {
    res.sendFile(path.join(__dirname, "/login.html"))
});
// app.get("/users", (req, res) => {
//     res.sendFile(path.join(__dirname, "/views/pagination.html"))
// });

app.post("/login", (req, res) => {
        // console.log("test");
        // const { username, password } = req.body;
        const username = req.body.username;
        const password = req.body.password;
    
        const sql = `SELECT username, role FROM user WHERE username='${username}' AND password='${password}'`;
        //    console.log(sql);
        con.query(sql, function (err, result, field) {
            if (err) {
                console.log(err);
                res.status(500).send("Database server error");
            } else {
                if (result[0].role == 1) {
                    res.send("/users");
                    //console.log("Success")
                }
                else {
                    res.send("/users");
                }

            }
        })
    });

//------ Get all users -----
app.get("/user", function (req,res){
    const sql = "SELECT id, username, role FROM user";
    con.query(sql,function(err,result){
        if(err){
            console.log(err);
            res.status(500).send("Database server error");
        } else {
            res.json(result);
        }
    });
});

//------- Delete user -------
app.delete("/user/:id", function(req,res){
    const id = req.params.id;
    const sql = "DELETE FROM user WHERE id=?";
    con.query(sql, [id], function(err,result){
        if(err){
            console.log(err);
            res.status(500).send("Database server error");
        } else {
            if(result.affectedRows == 1){
                res.send("Delete Done");
            } else {
                res.status(500).send("Delete error");
            }
        }
    });
});


//------- Add user ------
app.post("/user/add", function(req,res){
    const name = req.body.name;
    const pass = req.body.pass;
    const role = req.body.role;
    
    const sql = `INSERT TO user VALUE (NULL, username, password, role)`;

    database.query(sql, [username, password, role], function(err, result){
        if (err) {
            console.log(err);
            res.status(500).send("Database server error.");
        } else {
            if (result.affectedRows == 1) {
                res.send("New user has been added.");
            } else {
                res.status(501).send("Error while adding new user.");
            }
        }
    });
});

//---- Upload file
app.post("/uploading", function(req,res){
    upload(req,res, function(err){
        if(err){
            console.log(err);
            res.status(500).send("Upload error");
        }else{
            res.send("Upload done!");
        }
    })
});

//--- Register -----
app.post("/register", function(req,res){
    upload(req,res, function(err){
        if(err){
            console.log(err);
            res.status(500).send("Upload error");
        }else{
            //upload done to DB
            const username = req.body.username;
            const password = req.body.password;
            const filename = req.file.filename;

            //hash password
            bcrypt.hash(password, 10, function(err,hash){
                if(err){
                    console.log(err);
                    res.status(500).send("Hash error");
                }else{
                    //get hashed password
                    
                    //insert to DB
                    const sql = "INSERT INTO user (username, password, role, image) VALUES(?,?,2,?)";
                    con.query(sql, [username, hash, filename], function(err, result){
                        if(err){
                            console.log(err);
                            res.status(500).send("DB error");
                        }else{
                            res.send("done");
                        }
                    });
                }
            })
        }
    });
});

//--start server--
const PORT = 5000;
app.listen(PORT, (req, res) => {
    console.log("Server is running at " + PORT);
});
