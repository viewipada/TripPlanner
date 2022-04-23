Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Description: ========================
        sqlalchemy-postgres-copy
        ========================
        
        .. image:: https://img.shields.io/pypi/v/sqlalchemy-postgres-copy.svg
            :target: http://badge.fury.io/py/sqlalchemy-postgres-copy
            :alt: Latest version
        
        .. image:: https://img.shields.io/travis/jmcarp/sqlalchemy-postgres-copy.svg
            :target: https://travis-ci.org/jmcarp/sqlalchemy-postgres-copy
            :alt: Travis-CI
        
        **sqlalchemy-postgres-copy** is a utility library that wraps the PostgreSQL COPY_ command for use with SQLAlchemy. The COPY command offers performant exports from PostgreSQL to TSV, CSV, or binary files, as well as imports from files to PostgresSQL tables. Using COPY is typically much more efficient than importing and exporting data using Python.
        
        Installation
        ============
        
        ::
        
            pip install -U sqlalchemy-postgres-copy
        
        Usage
        =====
        
        ::
        
            import postgres_copy
            from models import Album, session, engine
        
            # Export a CSV containing all Queen albums
            query = session.query(Album).filter_by(artist='Queen')
            with open('/path/to/file.csv', 'w') as fp:
                postgres_copy.copy_from(query, fp, engine, format='csv', header=True)
        
            # Import a tab-delimited file
            with open('/path/to/file.tsv') as fp:
                postgres_copy.copy_to(fp, Album, engine)
        
        .. _COPY: http://www.postgresql.org/docs/9.5/static/sql-copy.html
        
Keywords: sqlalchemy,postgresql
Platform: UNKNOWN
Classifier: Development Status :: 2 - Pre-Alpha
Classifier: Intended Audience :: Developers
Classifier: License :: OSI Approved :: MIT License
Classifier: Natural Language :: English
Classifier: Programming Language :: Python :: 2
Classifier: Programming Language :: Python :: 2.7
Classifier: Programming Language :: Python :: 3
Classifier: Programming Language :: Python :: 3.3
Classifier: Programming Language :: Python :: 3.4
