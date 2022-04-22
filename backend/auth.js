const { Role, UserKaryawanRole, UserKaryawan } = require('./models')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const salt = 10;

const login = async (request, response) => {
  try {
    // is username exist ?
    user = await UserKaryawan.findOne({
      where: {
        username: request.body.username,
      },
    })


    if (!user) {
      return response.status(403).json({
        "message": "User not found"
      })
    }

    // is password valid ?
    const validPassword = bcrypt.compareSync(request.body.password, user.password)
    if (!validPassword) {
      return response.status(401).json({
        "message": "Wrong Password"
      });
    }
    // troll the password value
    user.password = 'Hello There'

    console.log(user.id)

    // fetch the user's roles    
    const roles = await Role.findAll(
      {
        include: [{
          model: UserKaryawanRole,
          as: 'user_karyawan_role',
          where: { id_user_karyawan: user.id },
          attributes: []
        }]
      }
    )

    const rolesForJWT = roles.map(role => role.name)


    // ok give them a token then...
    const data = {
      "name": user.name,
      "email": user.email,
      "https://hasura.io/jwt/claims": {
        "x-hasura-allowed-roles": rolesForJWT,
        "x-hasura-default-role": rolesForJWT[0],
        "x-hasura-user-id": user.id
      }
    }
    token = jwt.sign(data, '99273-jg932-0i8yh2-83c0ss-owkekf-hjk43123-jfidi23-oopprogramming', { algorithm: 'HS256' })

    return response.status(200).json({ user, token, roles })

  } catch (err) {
    console.log(err)
    return response.status(500).json({ error: 'Internal server error' });
  }


}




const signUp = (request, response) => {
  hashedPassword = bcrypt.hashSync(request.body.password, salt);
}



module.exports = {
  login,
  signUp
}

    // fetch('http://graphql-engine:8080/v1/graphql', {
    //   method: 'post',
    //   headers: new fetch.Headers({
    //     'Authorization': `Bearer ${token}`,
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json'
    //   }),
    //   body: JSON.stringify({
    //     query: `query getRoles {
    //             user_karyawan_role(where: {id_user_karyawan: {_eq: "${user.id}"}}) {
    //               role {
    //                 name
    //               }
    //             }
    //           }
    //   ` }),
    // })
    //   .then(res => res.json())
    //   .then(gql => response.status(200).json({ user, token, gql }))