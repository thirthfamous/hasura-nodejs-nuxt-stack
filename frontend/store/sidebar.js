export const state = () => ({
  menu_admin: [
    {
      icon: 'icon-dashboard',
      name: 'Dashboard',
      roles: [1, 2, 3, 4, 5, 6],
      slug: '/dashboard'
    },
    {
      icon: 'icon-data-master',
      name: 'Data Master',
      roles: [1],
      id: 'collapse-expertise',
      sub_menus: [
        {
          icon: '',
          name: 'Bidang Keahlian',
          roles: [1],
          slug: '/admin/data-master/expertise-area'
        },
        {
          icon: '',
          name: 'Program Keahlian',
          roles: [1],
          slug: '/admin/data-master/expertise-program'
        }
      ]
    },
    {
      icon: 'icon-karyawan',
      name: 'Karyawan',
      roles: [1],
      slug: '/admin/employee'
    }
  ],
  menu_cs: [
    {}
  ]
})

export const mutations = {
  // for forum
  // set url forum and detail
  SET_FORUM_URL (state, payload) {
    localStorage.setItem('forumUrl', payload)
    state.forumUrl = payload
  }
}
export const getters = {
  get_admin: (state) => {
    return state.menu_admin
  }
}
