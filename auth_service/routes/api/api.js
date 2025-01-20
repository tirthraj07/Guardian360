const express = require('express');
const api_router = express.Router();

// nested api routes
// const api_students_router = require("./api.students/students")


api_router.get('/', (req,res)=>{
    res.send('API Endpoint');
})

// api_router.use('/students', api_students_router);



module.exports = api_router;
