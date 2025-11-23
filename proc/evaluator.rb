def tokenize_expression(expr)
    tokens = []
    i = 0
    expr = expr.gsub(/\s+/, '')

    while i < expr.length
        ch = expr[i]

        if ch =~ /\d|\./
            num = ch
            i += 1

            while i < expr.length && expr[i] =~ /\d|\./
                num << expr[i]
                i += 1
            end

            tokens << num

            next

        elsif '+-*/'.include?(ch)
            tokens << ch

        else
            # Ignore

        end

        i += 1
    end

    tokens
end

def to_rpn(tokens)
    output = []
    ops = []

    precedence = {
        '+' => 1,
        '-' => 1,
        '*' => 2,
        '/' => 2
    }

    tokens.each do |t|
        if t =~ /\A\d+(\.\d+)?\z/
            output << t
        else

        while !ops.empty? && precedence[ops.last] && precedence[ops.last] >= precedence[t]
            output << ops.pop
        end

        ops << t
        end
    end

    output.concat(ops.reverse)
end

def eval_rpn(rpn)
    stack = []

    rpn.each do |t|
        if t =~ /\A\d+(\.\d+)?\z/
            stack << t.to_f
        else

        b = stack.pop
        a = stack.pop

        raise 'Invalid expression' if a.nil? || b.nil?

        stack << case t
            when '+' then a + b
            when '-' then a - b
            when '*' then a * b
            when '/' then a / b
            else
                raise "Unknown operator: #{t}"
            end
        end
    end

    raise 'Invalid expression' if stack.size != 1
    stack.first
end

def format_result(value)
    value = value.to_f
    rounded = value.round(10)

    if (rounded % 1).zero?
        rounded.to_i.to_s

    else
        s = rounded.round(6).to_s
        s.sub(/(\.\d*?[1-9])0+$/, '\1').sub(/\.0$/, '')

    end
end

def evaluate_expression(expr)
    tokens = tokenize_expression(expr)
    raise 'Empty' if tokens.empty?
    rpn = to_rpn(tokens)
    value = eval_rpn(rpn)
    raise 'Bad result' if value.nan? || value.infinite?
    format_result(value)
end
