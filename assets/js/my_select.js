let MySelect = {
  textInput() {
    return this.el.querySelector('input[type=text]')
  },

  hiddenField() {
    return this.el.querySelector('input[type=hidden]')
  },

  optionsContainer() {
    return document.getElementById(`${this.el.id}-options-container`)
  },

  closeDropdown() {
    this.optionsContainer().style.display = 'none'

    // If there are no options then we won't have had a highlighted option to remove
    if (this.options.length > 0) {
      this.removeHighlight()
    }
    this.option_index = -1
    this.show_dropdown = false
  },

  openDropdown() {
    this.optionsContainer().style.display = 'block'
    this.options[0].classList.add('bg-red-300')
    this.option_index = 0
    this.show_dropdown = true
  },

  removeHighlight() {
    this.options[this.option_index].classList.remove('bg-red-300')
  },

  addHighlight() {
    this.options[this.option_index].classList.add('bg-red-300')
    this.options[this.option_index].scrollIntoView({
      behavior: 'smooth',
      inline: 'center',
    })
  },

  prevOption() {
    if (this.show_dropdown && this.option_index > 0) {
      this.removeHighlight()
      this.option_index = this.option_index - 1
      this.addHighlight()
    }
  },

  nextOption() {
    if (this.show_dropdown) {
      if (this.option_index < this.options.length - 1) {
        this.removeHighlight()
        this.option_index = this.option_index + 1
        this.addHighlight()
      }
    } else {
      this.openDropdown()
    }
  },

  selectOption() {
    if (this.show_dropdown) {
      this.pushEventTo(this.el, 'selected', {
        component_id: this.el.id,
        id: this.options[this.option_index].dataset.id,
      })

      this.closeDropdown()
    }
  },

  updateOptions() {
    for (const option of this.options) {
      // Add mousedown rather than click event because we also have a blur event
      // which fires before click while mousedown fires before blur.
      option.addEventListener('mousedown', (elem) => {
        console.log(elem.currentTarget)
        this.pushEventTo(this.el, 'selected', {
          component_id: this.el,
          id: elem.currentTarget.dataset.id,
        })
        if (this.show_dropdown) {
          this.closeDropdown()
        }
      })
    }
  },

  init() {
    this.show_dropdown = false
    this.options = document.getElementsByClassName(`${this.el.id}-option`)
    this.option_index = -1
    this.updateOptions()

    this.textInput().addEventListener('click', () => {
      // Show or hide the list of options
      if (this.show_dropdown) {
        this.closeDropdown()
      } else {
        this.openDropdown()
      }
    })

    this.textInput().addEventListener('blur', () => {
      // It is possible that the user hasn't entered a valid value.
      // In which case lets get the last known good value from the server.
      this.pushEventTo(this.el, 'blur', {})

      if (this.show_dropdown) {
        this.closeDropdown()
      }
    })

    this.textInput().onkeydown = (event) => {
      switch (event.code) {
        case 'ArrowUp':
          this.prevOption()
          break
        case 'ArrowDown':
          this.nextOption()
          break
        case 'Enter':
          event.preventDefault()
          this.selectOption()
          break
        default:
          if (!this.show_dropdown && this.options.length > 0) {
            this.openDropdown()
          }
          break
      }
    }
  },

  mounted() {
    this.init()

    this.handleEvent('select', ({ component_id, selected_option }) => {
      if (this.el.id == component_id) {
        this.textInput().value = selected_option.name
        this.hiddenField().value = selected_option.id
      }
    })
  },

  updated() {
    this.options = document.getElementsByClassName(`${this.el.id}-option`)
    this.updateOptions()
    if (this.show_dropdown && this.options.length > 0) {
      this.openDropdown()
    }
  },
}
export default MySelect
