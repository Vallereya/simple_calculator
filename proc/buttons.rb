def create_buttons(parent, result_entry, handler)
    buttons = [
        %w[% CE C /],
        %w[7 8 9 *],
        %w[4 5 6 +],
        %w[1 2 3 -],
        %w[< 0 . =]
    ]

    parent.vertical_box do
        buttons.each do |row|
            horizontal_box do
                row.each do |btn|
                    button(btn) do
                        stretchy true
                        on_clicked do
                            case btn

                            when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
                                handler.call(btn)

                            when '/', '*', '+', '-'
                                handler.call(btn)

                            when '%'
                                handler.call(:percent)

                            when '.'
                                handler.call(:decimal)

                            when '='
                                handler.call(:equals)

                            when 'C'
                                handler.call(:clear)

                            when 'CE'
                                handler.call(:clear)

                            when '<'
                                handler.call(:delete)

                            else
                                handler.call(btn)
                                
                            end
                        end
                    end
                end
            end
        end
    end
end
