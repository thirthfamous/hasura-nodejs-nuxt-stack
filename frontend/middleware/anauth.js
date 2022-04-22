export default function ({ app, redirect, route }) {
  // If the user is not authenticated
  const token = app.$cookies.get('token')
  if (!token) {
    if (route.fullPath !== '/login') { return redirect('/login') }
  } else if (route.fullPath !== '/') { return redirect('/') }
}
