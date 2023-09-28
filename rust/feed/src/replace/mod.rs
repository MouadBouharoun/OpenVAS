//! Replaces the function calls within a feed.

use std::error::Error;

use nasl_syntax::Statement;

pub struct Replacer {}

impl Replacer {
    fn find_calls(s: &Statement) -> Vec<&Statement> {
        s.find(&|s| matches!(s, Statement::Call(..)))
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
mod functions {
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
        let results: usize = nasl_syntax::parse(code)
            .filter_map(|s| s.ok())
            .map(|s| s.find(&|s| matches!(s, Statement::Call(..))).len())
            .sum();

        assert_eq!(results, 10);
    }
}
