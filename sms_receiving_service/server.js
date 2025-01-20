const express = require("express");
const cors = require("cors");
const cookieParser = require('cookie-parser');
const xss = require('xss-clean');

const app = express();
app.use(cors());
app.options('*', cors());
app.use(express.urlencoded({extended:true}))
app.use(express.json())
app.use(cookieParser());
app.use(xss());

app.get("/", (req, res) => {
    res.send("Hello World!");
})

app.post("/receive_sms", (req, res) => {

    console.log(req.body);
    res.json({ message: "SMS received successfully" });
    
});


app.listen(3000, () => {
    console.log("Server is running on port 3000");
});