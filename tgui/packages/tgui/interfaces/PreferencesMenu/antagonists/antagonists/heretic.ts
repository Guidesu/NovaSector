import { multiline } from 'common/string';

import { Antagonist, Category } from '../base';

export const HERETIC_MECHANICAL_DESCRIPTION = multiline`
      Find hidden influences and focus to find new
      powers and get stronger as one of several paths.
   `;

const Psyonaut: Antagonist = {
  key: 'heretic',
  name: 'Psyonaut',
  description: [
    multiline`
      The psynodes, the focus rises. It is time to meditate and focus.
    `,
    HERETIC_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Psyonaut;
