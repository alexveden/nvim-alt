def autoscroll_console_widget(wrapped_func):
    def _w(self, *args, **kwargs):
        result = wrapped_func(self, *args, **kwargs)
        # This functions belongs to ConsoleWidget
        self._scroll_to_end()
        return result

    return _w


if __name__ == "__main__":
    from qtconsole.qtconsoleapp import main
    from qtconsole.console_widget import ConsoleWidget

    ConsoleWidget._append_custom = autoscroll_console_widget(
        ConsoleWidget._append_custom
    )
    main()
