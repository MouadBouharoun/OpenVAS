//! Replaces the function calls within a feed.

use std::error::Error;

use nasl_syntax::Statement;

pub struct Replacer {}

impl Replacer {
    fn find_calls(s: &Statement) -> Vec<&Statement> {
        match s {
            Statement::Primitive(_)
            | Statement::AttackCategory(_)
            | Statement::Variable(_)
            | Statement::NoOp(_)
            | Statement::EoF
            | Statement::Break
            | Statement::Array(_, None)
            | Statement::Continue => return vec![],
            // array of statements
            Statement::Declare(_, stmts)
            | Statement::Operator(_, stmts)
            | Statement::Block(stmts) => {
                let mut results = vec![];
                for s in stmts {
                    results.extend(Self::find_calls(s))
                }
                return results;
            }
            // single box
            Statement::Exit(stmt)
            | Statement::Return(stmt)
            | Statement::Include(stmt)
            | Statement::Array(_, Some(stmt)) => {
                let mut results = vec![];
                results.extend(Self::find_calls(&stmt));
                return results;
            },
            // we need to scan deeper
            Statement::While(stmt, stmt2) |
            Statement::Repeat(stmt, stmt2) |
            Statement::ForEach(_, stmt, stmt2) |
            Statement::Assign(_, _, stmt, stmt2) => {
                let mut results = vec![];
                results.extend(Self::find_calls(&stmt));
                results.extend(Self::find_calls(&stmt2));
                return results;
            },
            Statement::If(stmt, stmt2, stmt3) => {
                let mut results = vec![];
                results.extend(Self::find_calls(&stmt));
                results.extend(Self::find_calls(&stmt2));
                if let Some(stmt3) = stmt3 {
                    results.extend(Self::find_calls(&stmt3));
                }
                return results;
            },
            Statement::For(stmt, stmt2, stmt3, stmt4) => {
                let mut results = vec![];
                results.extend(Self::find_calls(&stmt));
                results.extend(Self::find_calls(&stmt2));
                results.extend(Self::find_calls(&stmt3));
                results.extend(Self::find_calls(&stmt4));
                return results;
            },
            Statement::FunctionDeclaration(_, stmts, stmt) => {
                let mut results = vec![];
                results.extend(Self::find_calls(&stmt));
                for stmt in stmts {
                    results.extend(Self::find_calls(&stmt));
                }
                return results;
            },
            // that's what we want
            // TODO check parameter for function calls
            Statement::Call(_, _) => vec![s],
            // should not happen as they are in call
            Statement::Parameter(_)| 
            Statement::NamedParameter(_, _) => vec![],
        }
    }
    pub fn correct_functions(&self, code: &str) -> Result<String, Box<dyn Error>> {
        let mut result = String::new();
        for s in nasl_syntax::parse(code) {
            let s = s?;
            for call in Self::find_calls(&s) {
                result.push_str(&call.to_string());
            }
        }
        Ok(result)
    }
}

#[cfg(test)]
mod functions{
    use super::*;
    #[test]
    fn find() {
        let code = r#"
        function test(a, b) {
            return funker(a + b);
        }
        a = funker(1);
        while (funker(1) == 1) {
           if (funker(2) == 2) {
               return funker(2);
           } else {
              for ( i = funker(3); i < funker(5) + funker(5); i + funker(1)) 
                exit(funker(10));
           }
        }
        "#;
        let mut results = 0;
        for s in nasl_syntax::parse(code) {
            let s = s.unwrap();
            results += Replacer::find_calls(&s).len();
        }
        assert_eq!(results, 10);
    }

}
