// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html'
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import live_select from 'live_select'
import MySelect from './my_select'

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

const hooks = {
  ReportCategory: {
    textInput() {
      return this.el.querySelector('input[type=text]')
    },

    setInputValue(value, { focus }) {
      this.textInput().value = value
      if (focus) {
        this.textInput().focus()
      }
    },
    attachDomEventHandlers() {
      this.textInput().onkeydown = (event) => {
        if (event.code === 'Enter') {
          event.preventDefault()
        }
        this.pushEventTo(this.el, 'keypress', { key: event.code })
      }
    },
    mounted() {
      this.attachDomEventHandlers()
      this.handleEvent('change', ({ id, selected_label }) => {
        this.setInputValue(selected_label, { focus, blur })
        var element = document.getElementById(`${id}-options-container`)
        element.style.display = 'none'
      })
    },

    updated() {
      this.attachDomEventHandlers()
    },
  },
  Simple: {
    textInput() {
      return this.el.querySelector('input[type=text]')
    },
    attachDomEventHandlers() {
      this.textInput().onkeydown = (event) => {
        if (event.code === 'Enter') {
          this.pushEventTo(this.el, 'option_select', { key: event.code })
        } else {
          this.pushEventTo(this.el, 'keypress', { key: event.code })
        }
      }
    },
    mounted() {
      console.log("simple mounted")
      this.attachDomEventHandlers()
    },

    updated() {
      this.attachDomEventHandlers()
    },
  },
  live_select,
  MySelect
}
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks,
})
console.log(hooks)
// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', (info) =>
  topbar.delayedShow(200)
)
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
